import 'package:flame/components.dart';
import 'package:gift_grab/presentation/games/gift_grab_flame_game.dart';
import 'package:gift_grab/data/constants/globals.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameRef<GiftGrabFlameGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Globals.backgroundSprite);
    size = gameRef.size;
  }
}
