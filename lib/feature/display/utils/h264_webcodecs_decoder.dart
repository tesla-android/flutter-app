import 'dart:typed_data';
import 'dart:js_interop';

import 'package:tesla_android/common/utils/logger.dart';

import 'webcodecs_bindings.dart';

typedef FrameCallback = void Function(VideoFrame frame);
typedef ErrorCallback = void Function(JSAny? error);

class _PendingChunk {
  final String type; // 'key' | 'delta'
  _PendingChunk(this.type);
}

class H264WebCodecsDecoder with Logger {
  final int codedWidth;
  final int codedHeight;
  final int displayWidth;
  final int displayHeight;
  final int maxBufferSize;
  final bool debug;

  final FrameCallback onFrame;
  final ErrorCallback? onError;

  late final VideoDecoder _decoder;
  Uint8List? _sps;

  final List<_PendingChunk> _pendingChunks = [];

  int skippedFrames = 0;
  int _messageCount = 0;
  int _nalSplitCount = 0;

  H264WebCodecsDecoder({
    required this.codedWidth,
    required this.codedHeight,
    required this.displayWidth,
    required this.displayHeight,
    required this.onFrame,
    this.onError,
    this.maxBufferSize = 60,
    this.debug = false,
  }) {
    _log('Ctor: codedWidth=$codedWidth codedHeight=$codedHeight '
        'displayWidth=$displayWidth displayHeight=$displayHeight '
        'maxBufferSize=$maxBufferSize');

    _decoder = VideoDecoder(
      VideoDecoderInit(
        output: _onOutputJS.toJS,
        error: _onErrorJS.toJS,
      ),
    );

    _log('Decoder created, initial state="${_decoder.state}"');
  }

  void _log(String msg) {
    if (!debug) return;
    log('[H264WebCodecsDecoder] $msg');
  }

  void handleMessage(Uint8List dat) {
    _messageCount++;
    _log('handleMessage #$_messageCount: len=${dat.length}, '
        'firstBytes=${_hexPrefix(dat, 8)}');

    if (dat.length < 5) {
      _log('handleMessage: len < 5 → dropping packet');
      return;
    }

    final unittype = dat[4] & 0x1f;
    _log('handleMessage: unittype=$unittype');

    if (unittype == 1 || unittype == 5) {
      _log('handleMessage: slice NAL (type=$unittype) → _videoMagic');
      _videoMagic(dat);
    } else {
      _log('handleMessage: non-slice NAL, calling _separateNalUnits + _headerMagic');
      final nals = _separateNalUnits(dat);
      _log('handleMessage: _separateNalUnits returned ${nals.length} NAL(s)');
      for (final nal in nals) {
        if (nal.length < 5) {
          _log('headerMagic: nal.len < 5 → skip');
          continue;
        }
        final t = nal[4] & 0x1f;
        _log('headerMagic: processing NAL len=${nal.length}, type=$t');
        _headerMagic(nal);
      }
    }

    _trimPendingFramesBufferIfNeeded();
  }

  void dispose() {
    _log('dispose(): clearing pending metadata and closing decoder '
        'state="${_decoder.state}"');
    _pendingChunks.clear();
    if (_decoder.state != 'closed') {
      _decoder.close();
    }
  }

  void _videoMagic(Uint8List dat) {
    if (dat.length < 5) {
      _log('_videoMagic: dat.len < 5 → dropping');
      return;
    }
    final unittype = dat[4] & 0x1f;

    String? type;
    Uint8List data;

    if (unittype == 1) {
      type = 'delta';
      data = dat;
      _log('_videoMagic: delta frame, len=${data.length}');
    } else if (unittype == 5) {
      if (_sps == null) {
        _log('_videoMagic: key frame but _sps == null → cannot prepend SPS, dropping');
        return;
      }
      type = 'key';
      data = _appendByteArray(_sps!, dat);
      _log('_videoMagic: key frame, originalLen=${dat.length}, spsLen=${_sps!.length}, '
          'combinedLen=${data.length}');
    } else {
      _log('_videoMagic: unittype=$unittype not 1/5 → ignoring');
      return;
    }

    final decoderState = _decoder.state;
    _log('_videoMagic: decoder.state="$decoderState"');

    if (decoderState == 'configured') {
      final chunkInit = EncodedVideoChunkInit(
        type: type,
        timestamp: 0,
        duration: 0,
        data: data.toJS,
      );
      final chunk = EncodedVideoChunk(chunkInit);

      _pendingChunks.add(_PendingChunk(type));
      _log('_videoMagic: added chunk type=$type, pendingChunks=${_pendingChunks.length}');

      _trimPendingFramesBufferIfNeeded();

      _log('_videoMagic: calling decode()');
      _decoder.decode(chunk);
    } else {
      _log('_videoMagic: decoder NOT configured, cannot decode');
      onError?.call('Decoder not configured when trying to decode frame'.toJS);
    }
  }

  void _headerMagic(Uint8List dat) {
    if (dat.length < 5) {
      _log('_headerMagic: len < 5 → dropping');
      return;
    }
    final unittype = dat[4] & 0x1f;

    if (unittype == 7) {
      _log('_headerMagic: SPS NAL detected (type=7), len=${dat.length}');
      final config = _buildConfigFromSps(dat);
      _sps = dat;
      _log('_headerMagic: configuring decoder with codec="${config.codec}" '
          'codedWidth=$codedWidth codedHeight=$codedHeight');
      _decoder.configure(config);
      _log('_headerMagic: decoder.state after configure="${_decoder.state}"');
    } else if (unittype == 8) {
      _log('_headerMagic: PPS NAL detected (type=8), len=${dat.length}');
      if (_sps != null) {
        _sps = _appendByteArray(_sps!, dat);
        _log('_headerMagic: appended PPS to SPS, new spsLen=${_sps!.length}');
      } else {
        _sps = dat;
        _log('_headerMagic: PPS without previous SPS, storing as _sps len=${_sps!.length}');
      }
    } else {
      _log('_headerMagic: other NAL type=$unittype → _videoMagic');
      _videoMagic(dat);
    }
  }

  VideoDecoderConfig _buildConfigFromSps(Uint8List dat) {
    final sb = StringBuffer('avc1.');
    for (var i = 5; i < 8 && i < dat.length; i++) {
      var h = dat[i].toRadixString(16);
      if (h.length < 2) h = '0$h';
      sb.write(h);
    }
    final codec = sb.toString();
    _log('_buildConfigFromSps: built codec="$codec" from SPS');

    return VideoDecoderConfig(
      codec: codec,
      codedHeight: codedHeight,
      codedWidth: codedWidth,
      displayAspectWidth: displayWidth,
      displayAspectHeight: displayHeight,
      hardwareAcceleration: 'prefer-hardware',
      optimizeForLatency: true,
    );
  }

  void _onOutputJS(VideoFrame frame) {
    _handleOutputFrame(frame);
  }

  void _onErrorJS(JSAny? error) {
    _handleError(error);
  }

  void _handleOutputFrame(VideoFrame frame) {
    _log('_handleOutputFrame: got frame '
        'codedWidth=${frame.codedWidth}, codedHeight=${frame.codedHeight}, '
        'format=${frame.format}');
    onFrame(frame);
  }

  void _handleError(JSAny? error) {
    _log('_handleError: $error');
    onError?.call(error);
  }

  void _trimPendingFramesBufferIfNeeded() {
    if (_pendingChunks.length <= maxBufferSize) return;

    _log('_trimPendingFramesBufferIfNeeded: pendingChunks=${_pendingChunks.length} '
        'maxBufferSize=$maxBufferSize → trimming');

    var foundIframe = false;
    while (!foundIframe && _pendingChunks.isNotEmpty) {
      final p = _pendingChunks.removeAt(0);

      _log('_trimPendingFramesBufferIfNeeded: popped chunk type=${p.type}');

      if (p.type == 'key') {
        foundIframe = true;
        _pendingChunks.insert(0, p);
        _log('_trimPendingFramesBufferIfNeeded: found keyframe, putting it back at head');
      } else {
        skippedFrames++;
        _log('_trimPendingFramesBufferIfNeeded: dropped non-keyframe, '
            'skippedFrames=$skippedFrames');
      }
    }

    _log('_trimPendingFramesBufferIfNeeded: done, pendingChunks=${_pendingChunks.length}');
  }

  Uint8List _appendByteArray(Uint8List a, Uint8List b) {
    final out = Uint8List(a.length + b.length);
    out.setRange(0, a.length, a);
    out.setRange(a.length, a.length + b.length, b);
    return out;
  }

  List<Uint8List> _separateNalUnits(Uint8List data) {
    final result = <Uint8List>[];
    int? startIndex;

    bool isStartCode(int i) {
      if (i + 3 >= data.length) return false;
      return data[i] == 0 &&
          data[i + 1] == 0 &&
          data[i + 2] == 0 &&
          data[i + 3] == 1;
    }

    for (var i = 0; i < data.length; i++) {
      if (isStartCode(i)) {
        if (startIndex != null) {
          result.add(Uint8List.sublistView(data, startIndex, i));
          _nalSplitCount++;
        }
        startIndex = i;
      }
    }

    if (startIndex != null && startIndex < data.length) {
      result.add(Uint8List.sublistView(data, startIndex));
      _nalSplitCount++;
    }

    _log('_separateNalUnits: dataLen=${data.length}, '
        'foundNALs=${result.length}, totalNALsSeen=$_nalSplitCount');

    return result;
  }

  String _hexPrefix(Uint8List data, int maxBytes) {
    final len = data.length < maxBytes ? data.length : maxBytes;
    final sb = StringBuffer();
    for (var i = 0; i < len; i++) {
      var h = data[i].toRadixString(16);
      if (h.length < 2) h = '0$h';
      if (i > 0) sb.write(' ');
      sb.write(h);
    }
    return sb.toString();
  }
}