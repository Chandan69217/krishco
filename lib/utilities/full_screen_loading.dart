import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FullScreenLoading extends StatelessWidget {
  const FullScreenLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Expanded(
          child: Container(
            color: Colors.black12,
          ),
        ),
        Center(
        child: Positioned.fill(
          child: Lottie.asset(
            'assets/logo/loading_indicator.json',
            fit: BoxFit.cover,
            repeat: true,
          ),
        ),
      ),
      ]
    );
  }
}
