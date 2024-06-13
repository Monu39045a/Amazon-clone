import 'package:amazon_clone/constants/global_variable.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1,
        height: 220,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlay: true,
      ),
      items: GlobalVariables.carouselImages.map(
        (i) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Builder(
              builder: (BuildContext context) {
                return Image.network(
                  i,
                  fit: BoxFit.cover,
                  height: 250,
                );
              },
            ),
          );
        },
      ).toList(),
    );
  }
}
