import 'package:balls_n_mazes/widgets/banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:balls_n_mazes/models/player_data.dart';
import 'package:balls_n_mazes/screens/game_play_screen.dart';
import 'package:provider/provider.dart';

class SelectLevelScreen extends StatelessWidget {
  const SelectLevelScreen({super.key});

  void goToLevel(int containerNum, BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => GamePlayScreen(
                  levelNum: '$containerNum',
                )),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final playerData = Provider.of<PlayerData>(context, listen: false);
    // Generate the grid
    final List<Widget> levels =
        List.generate(3, (index) => _buildGridPage(index, context, playerData));

    levels.add(_moveLevels());

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Text('Levels',
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
              SizedBox(
                width: width * 0.9,
                height: height * 0.45,
                child: CarouselSlider.builder(
                  itemCount: levels.length,
                  slideIndicator: CircularSlideIndicator(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      currentIndicatorColor: Colors.white),
                  slideBuilder: (index) {
                    final level = levels[index];
                    return Center(child: level);
                  },
                ),
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
      ),
      bottomNavigationBar: const BannerWidget(),
    );
  }

  Widget _moveLevels() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue,
        border: Border.all(
          color: Colors.blueGrey,
          width: 2,
        ),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text(
            'Coming Soon',
            style: TextStyle(fontSize: 40, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildGridPage(
      int pageIndex, BuildContext context, PlayerData playerData) {
    final List<Widget> gridItems = List.generate(16, (index) {
      final int containerNumber = (index + (pageIndex * 16)) + 1;
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Material(
          child: GestureDetector(
            onTap: playerData.isLevelOpen(containerNumber)
                ? () => goToLevel(containerNumber, context)
                : null,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  color: playerData.isLevelCompleted(containerNumber)
                      ? const Color.fromARGB(255, 235, 217, 115)
                      : playerData.isLevelOpen(containerNumber)
                          ? Colors.white
                          : Colors.grey),
              child: Stack(
                children: [
                  Center(
                      child: Text(
                    '$containerNumber',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                  playerData.isLevelCompleted(containerNumber)
                      ? Positioned(
                          bottom: 1.0,
                          right: 5.0,
                          child: Text(
                              ' ${playerData.stopwatchToString(containerNumber)} '))
                      : Container(),
                  playerData.isLevelCompleted(containerNumber)
                      ? Positioned(
                          top: 1.0,
                          left: 2.0,
                          child:
                              Text(' ${playerData.getBadge(containerNumber)} '))
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      );
    });
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue,
        border: Border.all(
          color: Colors.blueGrey,
          width: 2,
        ),
      ),
      child: GridView.count(
        crossAxisCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        children: gridItems,
      ),
    );
  }
}
