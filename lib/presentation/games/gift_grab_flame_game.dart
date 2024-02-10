import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:gift_grab/util/config/screens.dart';
import 'package:gift_grab/presentation/components/background_component.dart';
import 'package:gift_grab/presentation/components/cookie_component.dart';
import 'package:gift_grab/presentation/components/flame_component.dart';
import 'package:gift_grab/presentation/components/gift_component.dart';
import 'package:gift_grab/presentation/components/ice_component.dart';
import 'package:gift_grab/presentation/components/santa_component.dart';
import 'package:gift_grab/util/config/globals.dart';
import 'package:gift_grab/presentation/inputs/joystick.dart';
import 'dart:math';

class GiftGrabFlameGame extends FlameGame
    with DragCallbacks, HasCollisionDetection {
  GiftGrabFlameGame();

  /// The Santa character who collects the gifts.
  final SantaComponent _santaComponent = SantaComponent(joystick: joystick);

  /// Background of snow landscape.
  final BackgroundComponent _backgroundComponent = BackgroundComponent();

  /// The first gift to collect.
  final GiftComponent _giftComponent = GiftComponent();

  /// Flame powerup.
  final FlameComponent _flameComponent = FlameComponent(
    startPosition: Vector2(200, 200),
  );

  /// Number of presents Santa has grabbed.
  int score = 0;

  /// Total seconds for each game.
  static int _remainingTime = Globals.gameTimeLimit;

  int _flameRemainingTime = Globals.flameTimeLimit;

  /// Timer for game.
  late Timer gameTimer;

  /// Timer for flame power up duration.
  late Timer flameTimer;

  /// Text UI component for score.
  late TextComponent _scoreText;

  /// Text UI component for timer.
  late TextComponent _timerText;

  /// Text UI component for flame counter.
  late TextComponent flameTimerText;

  /// Time when the flame appears.
  static int _flameTimeAppearance = _getRandomInt(
    min: (_remainingTime / 2).round(),
    max: _remainingTime,
  );

  /// Time when the flame appears.
  static int _cookieTimeAppearance = _getRandomInt(
    min: (_remainingTime / 2).round(),
    max: _remainingTime,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Configure countdown timer.
    gameTimer = Timer(
      1,
      repeat: true,
      onTick: () {
        if (_remainingTime == 0) {
          // Pause the game.
          pauseEngine();
          // Display game over menu.
          addMenu(menu: Screens.gameOver);
        } else if (_remainingTime == _flameTimeAppearance) {
          // Display the flame powerup.
          add(_flameComponent);
        } else if (_remainingTime == _cookieTimeAppearance) {
          // Display the cookie powerup.
          add(CookieComponent());
        }

        // Decrement time by one second.
        _remainingTime -= 1;
      },
    );

    flameTimer = Timer(
      1,
      repeat: true,
      onTick: () {
        if (_flameRemainingTime == 0) {
          _santaComponent.unflameSanta();
          flameTimerText.removeFromParent();
        } else {
          _flameRemainingTime -= 1;
        }
      },
    );

    // Preload audio files.
    await FlameAudio.audioCache.loadAll(
      [
        Globals.freezeSound,
        Globals.itemGrabSound,
        Globals.flameSound,
      ],
    );

    // Add background.
    add(_backgroundComponent);

    // Add initial gift.
    add(_giftComponent);

    // Add ice blocks.
    add(IceComponent(startPosition: Vector2(200, 200)));
    add(IceComponent(startPosition: Vector2(size.x - 200, size.y - 200)));

    // Add santa.
    add(_santaComponent);

    // Add joystick.
    add(joystick);

    // Add ScreenHitBox for boundries for ice blocks.
    add(ScreenHitbox());

    // Configure TextComponent
    _scoreText = TextComponent(
      text: 'Score: $score',
      position: Vector2(40, 50),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.white.color,
          fontSize: Globals.isTablet ? 50 : 25,
        ),
      ),
    );

    // Add Score TextComponent.
    add(_scoreText);

    // Configure TextComponent
    _timerText = TextComponent(
      text: 'Time: $score',
      position: Vector2(size.x - 40, 50),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.white.color,
          fontSize: Globals.isTablet ? 50 : 25,
        ),
      ),
    );

    // Add Score TextComponent.
    add(_timerText);

    // Configure TextComponent
    flameTimerText = TextComponent(
      text: 'Flame Time: $_flameRemainingTime',
      position: Vector2(size.x - 40, size.y - 100),
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: TextStyle(
          color: BasicPalette.black.color,
          fontSize: Globals.isTablet ? 50 : 25,
        ),
      ),
    );

    gameTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    gameTimer.update(dt);

    if (_santaComponent.isFlamed) {
      flameTimer.update(dt);
      flameTimerText.text = 'Flame Time: $_flameRemainingTime';
    }

    _scoreText.text = 'Score: $score';
    _timerText.text = 'Time: $_remainingTime secs';
  }

  /// Reset game (score, time, etc).
  void reset() {
    // Scores
    score = 0;

    // Santa attributes.
    _santaComponent.isFlamed = false;
    _santaComponent.isFrozen = false;
    _santaComponent.resetSpeed();

    // Timers
    _remainingTime = Globals.gameTimeLimit;
    _flameRemainingTime = Globals.flameTimeLimit;

    // Time Appearences
    _flameTimeAppearance = _getRandomInt(
      min: (_remainingTime / 2).round(),
      max: _remainingTime,
    );
    _cookieTimeAppearance = _getRandomInt(
      min: (_remainingTime / 2).round(),
      max: _remainingTime,
    );

    // Sprites
    _flameComponent.removeFromParent();

    // Texts
    flameTimerText.removeFromParent();
  }

  void addMenu({
    required Screens menu,
  }) {
    overlays.add(menu.name);
  }

  void removeMenu({
    required Screens menu,
  }) {
    overlays.remove(menu.name);
  }

  static int _getRandomInt({
    required int min,
    required int max,
  }) =>
      Random().nextInt(max - min) + min;
}
