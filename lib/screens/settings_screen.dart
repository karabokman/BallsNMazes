import 'package:balls_n_mazes/widgets/banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:balls_n_mazes/models/settings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                      leading:
                          const Icon(Icons.music_note, color: Colors.white),
                      title: Text('Music',
                          style: Theme.of(context).textTheme.labelLarge),
                      trailing: Selector<Settings, bool>(
                        selector: (context, settings) =>
                            settings.backgroundMusic,
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
              const SizedBox(height: 30),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => _launchURL(
                            'https://www.facebook.com/profile.php?id=61557887409577'),
                        icon: const Icon(Icons.facebook),
                        color: Colors.white),
                    TextButton(
                      onPressed: () => _launchURL('https://www.bensound.com'),
                      child: const Text(
                          'Music by https://www.bensound.com License code: LN3JNCUTW0HCIFXR',
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BannerWidget(),
    );
  }
}
