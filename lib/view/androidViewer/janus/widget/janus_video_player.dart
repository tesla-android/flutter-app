import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:janus_client/janus_client.dart';
import 'package:tesla_android/common/di/ta_locator.dart';
import 'package:tesla_android/common/ui/constants/ta_timing.dart';

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
  double _videoAspectRatio = 0.75;
  bool _isSpinnerVisible = true;

  @override
  void initState() {
    super.initState();
    _initJanusClient();
  }

  @override
  void dispose() async {
    super.dispose();
    _destroyJanus();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: TATiming.animationDuration,
        child: _isSpinnerVisible
            ? const CircularProgressIndicator()
            : AspectRatio(
                aspectRatio: _videoAspectRatio,
                child: Stack(
                  children: [
                    _remoteVideoRenderer != null
                        ? RTCVideoView(
                            _remoteVideoRenderer!,
                            mirror: false,
                            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                          )
                        : const SizedBox(),
                    widget.touchScreenView,
                  ],
                ),
              ),
      ),
    );
  }

  void _initJanusClient() async {
    if (!mounted) {
      return;
    }
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
        setState(() {
          _isSpinnerVisible = false;
        });
      }
    });
  }

  void _restartVideoPlayer() {
    setState(() {
      _isSpinnerVisible = true;
    });
    _initJanusClient();
  }

  void _observeVideoSize() {
    _remoteVideoRenderer?.onResize = () {
      setState(() {
        final aspect = _remoteVideoRenderer!.videoWidth / _remoteVideoRenderer!.videoHeight;
        _videoAspectRatio = aspect > 0 ? aspect : 0.75;
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
