import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, this.assets}) : super(key: key);
  final String? assets;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: assets == null ? 0.2 : 0.5,
        child: LottieBuilder.asset(
            'assets/animations/${assets ?? 'loading'}.json'),
      ),
    );
  }
}
