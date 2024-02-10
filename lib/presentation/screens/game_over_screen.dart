import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gift_grab/util/config/globals.dart';
import 'package:gift_grab/util/config/screens.dart';
import 'package:gift_grab/util/config/providers.dart';
import 'package:gift_grab/presentation/widgets/screen_background_widget.dart';
import 'package:go_router/go_router.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final giftGrabFlameGame = ref.read(Providers.giftGrabFlameGameProvider);
    final nakamaLeaderboardAsyncNotifier =
        ref.watch(Providers.nakamaLeaderboardAsyncNotifierProvider.notifier);
    // nakamaLeaderboardAsyncNotifier.writeLeaderboardRecord(
    //     score: giftGrabFlameGame.score);
    final theme = Theme.of(context);
    return ScreenBackgroundWidget(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Game Over',
                style: theme.textTheme.displayLarge!.copyWith(
                  fontSize: Globals.isTablet
                      ? theme.textTheme.displayLarge!.fontSize! * 2
                      : theme.textTheme.displayLarge!.fontSize,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Score: ${giftGrabFlameGame.score}',
                style: theme.textTheme.displayLarge!.copyWith(
                  fontSize: Globals.isTablet
                      ? theme.textTheme.displayLarge!.fontSize! * 3
                      : theme.textTheme.displayLarge!.fontSize,
                ),
              ),
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  giftGrabFlameGame.removeMenu(menu: Screens.gameOver);
                  giftGrabFlameGame.reset();
                  giftGrabFlameGame.resumeEngine();
                },
                child: Text(
                  'Play Again?',
                  style: TextStyle(
                    fontSize: Globals.isTablet ? 50 : 25,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: Globals.isTablet ? 400 : 200,
              height: Globals.isTablet ? 100 : 50,
              child: ElevatedButton(
                onPressed: () {
                  giftGrabFlameGame.removeMenu(menu: Screens.gameOver);
                  giftGrabFlameGame.reset();
                  giftGrabFlameGame.resumeEngine();

                  context.pop();
                },
                child: Text(
                  'Main Menu',
                  style: TextStyle(
                    fontSize: Globals.isTablet ? 50 : 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
