import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_scape/screens/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen(); // THis opens the app in fullscreen mode

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['fonts'], license);
  });

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Tourney',
      scaffoldBackgroundColor: Colors.black,
    ),
    home: const MainMenu(),
  ));
}
