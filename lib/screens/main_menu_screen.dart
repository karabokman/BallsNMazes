import 'package:flutter/material.dart';
import 'package:balls_n_mazes/screens/settings_screen.dart';
import 'package:balls_n_mazes/screens/select_ball_screen.dart';
import 'package:balls_n_mazes/screens/tutorial_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Image.asset('assets/images/Misc/Banner.png',
                  width: 200, height: 50),
            ),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SelectBallScreen()));
                  },
                  child: const Text('Play')),
            ),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingsScreen()));
                  },
                  child: const Text('Settings')),
            ),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TutorialScreen()));
                  },
                  child: const Text('Help')),
            ),
          ],
        ),
      ),
    );
  }
}
