import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:neumodore/infra/services/audio/iaudio_service.dart';

class AudioServiceConcrete implements IAudioService {
  @override
  void playAudio() {
    AssetsAudioPlayer.newPlayer()
      ..setVolume(1)
      ..open(
        Audio('assets/sounds/robinhood76_04864.mp3'),
        loopMode: LoopMode.none,
        showNotification: true,
        playInBackground: PlayInBackground.enabled,
        audioFocusStrategy: AudioFocusStrategy.request(
          resumeAfterInterruption: true,
        ),
      )
      ..forwardOrRewind(1);
  }
}
