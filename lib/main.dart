import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:space_scape/providers/player_provider.dart';

import 'screens/main_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen(); // THis opens the app in fullscreen mode
  Flame.device.setPortraitUpOnly();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['fonts'], license);
  });

  final game = await myGame();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayerProvider>(
          create: (_) => PlayerProvider(),
        ),
      ],
      child: game,
    ),
  );
}

Future<MaterialApp> myGame() async {
  FlameAudio.bgm.initialize();
  await FlameAudio.bgm.play('SpaceSong.mp3');

    return MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Tourney',
      scaffoldBackgroundColor: Colors.black,
    ),
    home: const MainMenu(),
  );
}