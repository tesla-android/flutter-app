import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:janus_client/janus_client.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/ui/constants/ta_dimens.dart';
import 'package:tesla_android/common/ui/constants/ta_timing.dart';
import 'package:tesla_android/view/iframe/iframe_view.dart';

class JanusVideoPlayer extends StatefulWidget {
  final Widget touchScreenView;

  const JanusVideoPlayer({
    Key? key,
    required this.touchScreenView,
  }) : super(key: key);

  @override
  _JanusVideoPlayerState createState() => _JanusVideoPlayerState();
}

class _JanusVideoPlayerState extends State<JanusVideoPlayer> {
  final Flavor _flavor = getIt<Flavor>();

  JanusClient? _janusClient;
  WebSocketJanusTransport? _webSocketJanusTransport;
  JanusSession? _janusSession;
  JanusUstreamerPlugin? _janusPlugin;

  RTCVideoRenderer? _remoteVideoRenderer;
  MediaStream? _remoteVideoStream;
  double _videoAspectRatio = 1184 / 922;

  int _janusInitRetryCount = 0;
  final int _janusMaxRetryCount = 15;
  bool _shouldFallbackToMjpeg = false;
  bool _didResizeWebRTCStream = false;

  @override
  void initState() {
    super.initState();
    _initJanusClient();
    _checkIfVideoTagIsWorking();
  }

  @override
  void dispose() async {
    super.dispose();
    _destroyJanus();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: _videoAspectRatio,
        child: Stack(
          children: [
            _remoteVideoRenderer != null && _shouldFallbackToMjpeg == false
                ? RTCVideoView(
                    _remoteVideoRenderer!,
                    mirror: false,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )
                : const SizedBox(),
            if (_shouldFallbackToMjpeg) ...[
              const IframeView(source: "low-quality-stream.html"),
              Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                      padding: TADimens.halfBasePadding,
                      color: Colors.red,
                      child: const Text(
                          "Low quality mode forced by loading Tesla Android in motion, reload the page while in Park"))),
            ],
            PointerInterceptor(child: widget.touchScreenView),
          ],
        ),
      ),
    );
  }

  void _initJanusClient() async {
    if (!mounted || _janusInitRetryCount > _janusMaxRetryCount || _shouldFallbackToMjpeg)  {
      return;
    }
    _janusInitRetryCount++;
    setState(() {
      _webSocketJanusTransport = WebSocketJanusTransport(url: _flavor.getString("janusWebSocket"));
      _janusClient = JanusClient(
        transport: _webSocketJanusTransport!,
        iceServers: [
          RTCIceServer(
            username: _flavor.getString("janusTurnUsername"),
            credential: _flavor.getString("janusTurnPassword"),
            urls: _flavor.getString("janusTurnUrl"),
          ),
        ],
        isUnifiedPlan: true,
      );
    });
    try {
      _janusSession = await _janusClient?.createSession();
      _janusPlugin = await _janusSession?.attach<JanusUstreamerPlugin>();
      _requestVideoStream();
      _observeWebSocketState();
      _observeJanusPluginVideoTrack();
      _observeJanusPluginMessages();
      _janusInitRetryCount = 0;
    } catch (e) {
      await Future.delayed(TATiming.timeoutDuration, _initJanusClient);
    }
  }

  void _requestVideoStream() async {
    var body = {"request": "watch"};
    await _janusPlugin?.send(
      data: body,
    );
  }

  void _observeWebSocketState() {
    _webSocketJanusTransport?.stream.listen(
      (_) {},
      onError: (_) {
        _restartVideoPlayer();
      },
      onDone: () {
        _restartVideoPlayer();
      },
    );
  }

  void _observeJanusPluginVideoTrack() {
    _janusPlugin?.remoteTrack?.listen((event) async {
      if (event.track != null && event.flowing == true && event.track?.kind == 'video') {
        MediaStream temp = await createLocalMediaStream(event.track!.id!);
        setState(() {
          _remoteVideoRenderer = RTCVideoRenderer();
          _observeVideoSize();
          _remoteVideoStream = temp;
        });

        await _remoteVideoRenderer?.initialize();
        await _remoteVideoStream?.addTrack(event.track!);
        _remoteVideoRenderer?.srcObject = _remoteVideoStream;
      }
    });
  }

  void _observeJanusPluginMessages() {
    _janusPlugin?.messages?.listen((event) async {
      if (event.toString().contains("Haven't received SPS/PPS from memsink yet")) {
        await Future.delayed(TATiming.timeoutDuration, _requestVideoStream);
      }
      if (event.jsep != null) {
        await _janusPlugin?.handleRemoteJsep(event.jsep!);
        RTCSessionDescription? answer = await _janusPlugin?.createAnswer(
          audioSend: false,
          videoSend: false,
          videoRecv: true,
          audioRecv: false,
        );
        _janusPlugin?.send(data: {"request": "start"}, jsep: answer);
      }
    });
  }

  void _checkIfVideoTagIsWorking() async {
    await Future.delayed(TATiming.webRtcTimeoutDuration, () async {
      if (!_didResizeWebRTCStream) {
        setState(() {
          _shouldFallbackToMjpeg = true;
        });
        _destroyJanus();
      }
    });
  }

  void _restartVideoPlayer() {
    _initJanusClient();
  }

  void _observeVideoSize() {
    _remoteVideoRenderer?.onResize = () {
      setState(() {
        final aspect = _remoteVideoRenderer!.videoWidth / _remoteVideoRenderer!.videoHeight;
        if (aspect > 0) {
          _didResizeWebRTCStream = true;
          _videoAspectRatio = aspect;
        }
      });
    };
  }

  void _destroyJanus() async {
    stopAllTracksAndDispose(_remoteVideoStream);
    _remoteVideoRenderer?.srcObject = null;
    await _remoteVideoRenderer?.dispose();
    await _janusPlugin?.dispose();
    _janusSession?.dispose();
  }
}
