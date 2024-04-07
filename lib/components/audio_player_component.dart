import 'dart:async';

import 'package:flame/components.dart';
import 'package:balls_n_mazes/components/game.dart';
import 'package:balls_n_mazes/models/settings.dart';
import 'package:provider/provider.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioPlayerComponent extends Component with HasGameRef<MazeGame> {
  @override
  FutureOr<void> onLoad() {
    // Initialize audio player
    FlameAudio.bgm.initialize();
    FlameAudio.audioCache.loadAll([
      'checkpoint.wav',
      'blip.wav',
      'ghostmode.wav',
      'paint.wav',
      'background.mp3'
    ]);
    return super.onLoad();
  }

  void playBgm(String fileName) {
    // Play background music
    if (gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false)
          .backgroundMusic) {
        FlameAudio.bgm.play(fileName);
      }
    }
  }

  void playSfx(String fileName) {
    // Play sound effects
    if (gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false)
          .soundEffects) {
        FlameAudio.play(fileName);
      }
    }
  }

  void stopbgm() {
    // Stop background music
    FlameAudio.bgm.stop();
  }
}
