import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FullScreenLoading extends StatelessWidget {
  const FullScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black12,
        ),
        Center(
          child: Lottie.asset(
            'assets/logo/loading_indicator.json',
            width: 150, // Optional: set a specific size
            height: 150,
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),
      ],
    );
  }
}

