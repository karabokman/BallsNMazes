import 'package:flutter/material.dart';
import 'package:balls_n_mazes/models/settings.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
              child: Text('Settings',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            Container(
              width: width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.music_note, color: Colors.white),
                    title: Text('Music',
                        style: Theme.of(context).textTheme.labelLarge),
                    trailing: Selector<Settings, bool>(
                      selector: (context, settings) => settings.backgroundMusic,
                      builder: (context, value, child) {
                        return Switch(
                          value: value,
                          onChanged: (onChanged) {
                            Provider.of<Settings>(context, listen: false)
                                .backgroundMusic = onChanged;
                          },
                          activeColor: Colors.amber,
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.speaker, color: Colors.white),
                    title: Text('Sfx',
                        style: Theme.of(context).textTheme.labelLarge),
                    trailing: Selector<Settings, bool>(
                      selector: (context, settings) => settings.soundEffects,
                      builder: (context, value, child) {
                        return Switch(
                          value: value,
                          onChanged: (onChanged) {
                            Provider.of<Settings>(context, listen: false)
                                .soundEffects = onChanged;
                          },
                          activeColor: Colors.amber,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(Icons.arrow_back_ios_new)),
            ),
          ],
        ),
      ),
    );
  }
}
