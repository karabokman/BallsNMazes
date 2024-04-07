import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:balls_n_mazes/models/balls_details.dart';
import 'package:balls_n_mazes/models/player_data.dart';
import 'package:balls_n_mazes/screens/select_level_screen.dart';
import 'package:provider/provider.dart';

class SelectBallScreen extends StatelessWidget {
  const SelectBallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Text('Select',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            Consumer<PlayerData>(
              builder: (context, playerData, child) {
                final ball = Ball.getBallByType(playerData.ballType);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Ball: ${ball.name}'),
                    Row(
                      children: [
                        const Icon(Icons.flash_on),
                        const SizedBox(width: 3),
                        Text('${playerData.powerUps}'),
                      ],
                    ),
                    Text('Coins: ${playerData.coins}'),
                  ],
                );
              },
            ),
            SizedBox(
              height: height * 0.5,
              child: CarouselSlider.builder(
                itemCount: Ball.balls.length,
                slideIndicator: CircularSlideIndicator(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    indicatorBackgroundColor: Colors.blue,
                    currentIndicatorColor: Colors.white),
                slideBuilder: (index) {
                  final ball = Ball.balls.entries.elementAt(index).value;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ball.assetPath, width: 100, height: 100),
                      const SizedBox(height: 15),
                      Text('${ball.name} ball'),
                      Text('Cost: ${ball.cost}'),
                      Consumer<PlayerData>(
                        builder: ((context, playerData, child) {
                          final type = Ball.balls.entries.elementAt(index).key;
                          final isEquipped = playerData.isEquiped(type);
                          final isOwned = playerData.isOwned(type);
                          final canBuy = playerData.canBuy(type);
                          return ElevatedButton(
                            onPressed: isEquipped
                                ? null
                                : () {
                                    if (isOwned) {
                                      playerData.equip(type);
                                    } else {
                                      if (canBuy) {
                                        playerData.buy(type);
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.red,
                                                title: const Text(
                                                  'Insufficient funds',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                content: Text(
                                                  'Need ${ball.cost - playerData.coins} more coins',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              );
                                            });
                                      }
                                    }
                                  },
                            child: Text(isEquipped
                                ? 'Equipped'
                                : isOwned
                                    ? 'Select'
                                    : 'Buy'),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    final playerData =
                        Provider.of<PlayerData>(context, listen: false);
                    if (playerData.canBuyPowerUp()) {
                      playerData.buyPowerUp();
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.red,
                              title: const Text(
                                'Insufficient funds',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              content: Text(
                                'Need ${20 - playerData.coins} more coins',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          });
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.flash_on,
                        size: 20,
                      ),
                      Text(
                        '20 coins',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            ),
            SizedBox(
              width: width / 3,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SelectLevelScreen()));
                  },
                  child: const Text('Continue')),
            ),
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
