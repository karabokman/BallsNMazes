import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:balls_n_mazes/models/balls_details.dart';
import 'package:balls_n_mazes/models/player_data.dart';
import 'package:balls_n_mazes/models/settings.dart';
import 'package:balls_n_mazes/screens/main_menu_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  //initialize hive
  await initHive();

  runApp(MultiProvider(
    providers: [
      FutureProvider<PlayerData>(
        create: (BuildContext context) => getPlayerData(),
        initialData: PlayerData.fromMap(PlayerData.defaultData),
      ),
      FutureProvider<Settings>(
        create: (BuildContext context) => getSettings(),
        initialData: Settings(soundEffects: false, backgroundMusic: false),
      ),
    ],
    builder: (context, child) {
      return MultiProvider(providers: [
        ChangeNotifierProvider<PlayerData>.value(
          value: Provider.of<PlayerData>(context),
        ),
        ChangeNotifierProvider<Settings>.value(
          value: Provider.of<Settings>(context),
        ),
      ], child: child);
    },
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 235, 217, 115),
        primaryColor: Colors.teal,
        fontFamily: 'Lato',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16.0),
          labelLarge: TextStyle(color: Colors.white, fontSize: 15),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 16)),
          backgroundColor:
              MaterialStateProperty.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            } else if (states.contains(MaterialState.pressed)) {
              return const Color.fromARGB(255, 0, 88, 160);
            }
            return Colors.blue;
          }),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
        )),
      ),
      home: const MainMenuScreen(),
    ),
  ));
}

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(PlayerDataAdapter());
  Hive.registerAdapter(BallTypeAdapter());
  Hive.registerAdapter(SettingsAdapter());
}

Future<PlayerData> getPlayerData() async {
  final box = await Hive.openBox<PlayerData>(PlayerData.playerDataBox);
  final playerData = box.get(PlayerData.playerDataKey);

  if (playerData == null) {
    box.put(
        PlayerData.playerDataKey, PlayerData.fromMap(PlayerData.defaultData));
  }

  return box.get(PlayerData.playerDataKey)!;
}

Future<Settings> getSettings() async {
  final box = await Hive.openBox<Settings>(Settings.settingsBox);
  final settings = box.get(Settings.settingsKey);

  if (settings == null) {
    box.put(Settings.settingsKey,
        Settings(backgroundMusic: true, soundEffects: true));
  }

  return box.get(Settings.settingsKey)!;
}
