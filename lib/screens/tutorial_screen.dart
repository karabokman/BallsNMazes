import 'package:balls_n_mazes/widgets/banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:balls_n_mazes/models/tutorial_slides.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final tutSlides = Tutorial.slides;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Text('Tutorial',
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
              SizedBox(
                height: height * 0.5,
                child: CarouselSlider.builder(
                  itemCount: tutSlides.length,
                  slideIndicator: CircularSlideIndicator(
                      padding: const EdgeInsets.only(bottom: 10.0)),
                  slideBuilder: (index) {
                    var slide = tutSlides.elementAt(index);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          slide.assetPath,
                          width: width * 0.7,
                          height: width * 0.7,
                        ),
                        Text(
                          slide.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            slide.description,
                            textAlign: TextAlign.center,
                          ),
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
}
