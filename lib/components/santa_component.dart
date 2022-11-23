import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gift_grab/components/ice_component.dart';
import 'package:gift_grab/constants/globals.dart';
import 'package:gift_grab/games/gift_grab_game.dart';

/// States for when santa is idle, sliding left, or sliding right.
enum MovementState {
  idle,
  slideLeft,
  slideRight,
  frozen,
}

class SantaComponent extends SpriteGroupComponent<MovementState>
    with HasGameRef<GiftGrabGame>, CollisionCallbacks {
  /// Height of the sprite.
  final double _spriteHeight = 200.0;

  /// Max speed of sliding santa.
  final double _speed = 500.0;

  /// Joystick for movement.
  final JoystickComponent joystick;

  /// Screen boundries.
  late double _rightBound;
  late double _leftBound;
  late double _upBound;
  late double _downBound;

  /// Represents if Santa is frozen or not.
  bool _frozen = false;

  /// Countdown for how long Santa is frozen.
  final Timer _countdown = Timer(1);

  SantaComponent({required this.joystick});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Sprites.
    final Sprite santaIdle = await gameRef.loadSprite(Globals.santaIdle);
    final Sprite santaSlideLeft =
        await gameRef.loadSprite(Globals.santaSlideLeftSprite);
    final Sprite santaSlideRight =
        await gameRef.loadSprite(Globals.santaSlideRightSprite);
    final Sprite santaFrozen = await gameRef.loadSprite(Globals.santaFrozen);

    // Each sprite state.
    sprites = {
      MovementState.idle: santaIdle,
      MovementState.slideLeft: santaSlideLeft,
      MovementState.slideRight: santaSlideRight,
      MovementState.frozen: santaFrozen,
    };

    // Set right screen boundry.
    _rightBound = gameRef.size.x - 45;

    // Set left screen boundry.
    _leftBound = 0 + 45;

    // Set up screen boundry.
    _upBound = 0 + 55;

    // Set down screen boundry
    _downBound = gameRef.size.y - 55;

    // Set position of component to center of screen.
    position = gameRef.size / 2;

    // Set dimensions of santa sprite.
    width = _spriteHeight * 1.42;
    height = _spriteHeight;

    // Set anchor of component.
    anchor = Anchor.center;

    // Default current state to idle.
    current = MovementState.idle;

    add(CircleHitbox()..radius = 1);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // If Santa is not frozen, update position.
    if (!_frozen) {
      // If joystick is idle, set state to idle.
      if (joystick.direction == JoystickDirection.idle) {
        current = MovementState.idle;
        return;
      }

      // If player is exiting right screen boundry...
      if (x >= _rightBound) {
        // Set player back 1 pixel.
        x = _rightBound - 1;
      }

      // If player is exiting left screen boundry...
      if (x <= _leftBound) {
        // Set player back 1 pixel.
        x = _leftBound + 1;
      }

      // If player is exiting down screen boundry...
      if (y >= _downBound) {
        // Set player back 1 pixel.
        y = _downBound - 1;
      }

      // If player is exiting up screen boundry...
      if (y <= _upBound) {
        // Set player back 1 pixel.
        y = _upBound + 1;
      }

      // Determines if the component is moving left currently.
      bool moveLeft = joystick.relativeDelta[0] < 0;

      // If moving left, set state to slideLeft.
      if (moveLeft) {
        current = MovementState.slideLeft;
      }

      // Else, set state to slideRight.
      else {
        current = MovementState.slideRight;
      }

      // Update position.
      position.add(joystick.relativeDelta * _speed * dt);
    }
    // Else, start timer until unfrozen.
    else {
      _countdown.update(dt);
      if (_countdown.finished) {
        _frozen = false;
        current = MovementState.idle;
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // If Santa collides with an ice block, freeze him.
    if (other is IceComponent) {
      _frozen = true;
      current = MovementState.frozen;
      _countdown.start();
    }
  }
}