import 'package:flame/components.dart';
import 'package:balls_n_mazes/components/game.dart';
import 'package:balls_n_mazes/models/settings.dart';
import 'package:provider/provider.dart';
import 'package:flame_audio/flame_audio.dart';

class SfxPlayerComponent extends Component with HasGameRef<MazeGame> {
  void playSfx(String fileName) {
    // Play sound effects
    if (gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false)
          .soundEffects) {
        FlameAudio.play(fileName);
      }
    }
  }
}
