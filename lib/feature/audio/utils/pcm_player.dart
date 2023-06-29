import 'package:injectable/injectable.dart';
import 'package:js/js.dart';

typedef FeedPlayerFunc = dynamic Function();

@JS('feedPlayer')
external FeedPlayerFunc _feedPlayer(dynamic data);

typedef SetPlayerVolumeFunc = dynamic Function(dynamic volume);

@JS('setPlayerVolume')
external SetPlayerVolumeFunc _setPlayerVolume(dynamic volume);

@lazySingleton
class PcmAudioPlayer {
  void feed(data) {
    _feedPlayer(data);
  }

  void setVolume(double volume) {
    _setPlayerVolume(volume);
  }
}
