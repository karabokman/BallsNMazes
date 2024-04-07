import 'package:flutter/material.dart';
import 'package:balls_n_mazes/components/game.dart';

class DidYouKnowScreen extends StatelessWidget {
  static const String id = 'DidYouKnowScreen';
  final MazeGame gameRef;
  const DidYouKnowScreen({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Text('Did You Know',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            Image.asset(
              'assets/images/Misc/Did-You-Know.png',
              width: 200,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                ' ${gameRef.currentFact.title} ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                ' ${gameRef.currentFact.description} ',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
