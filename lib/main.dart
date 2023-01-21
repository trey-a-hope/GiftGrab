import 'package:flutter/material.dart';
import 'package:gift_grab/screens/game_play.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamePlay(),
    ),
  );
}
