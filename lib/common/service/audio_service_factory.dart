import 'package:tesla_android/common/service/audio_service.dart';
import 'package:tesla_android/common/service/audio_service_stub.dart'
    if (dart.library.js_interop) 'package:tesla_android/common/service/web_audio_service.dart';

class AudioServiceFactory {
  static AudioService create() {
    return createAudioService();
  }
}
