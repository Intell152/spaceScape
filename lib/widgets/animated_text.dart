import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  const AnimatedText({Key? key}) : super(key: key);

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  @override
  Widget build(BuildContext context) {
    
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.linear,
      duration: const Duration(seconds: 3),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: const Text(
            'Space Scape',
            style: TextStyle(
              fontSize: 50,
              color: Colors.black,
              shadows: [
                Shadow(
                  blurRadius: 15,
                  color: Colors.white,
                  offset: Offset.zero,
                ),
                Shadow(
                  blurRadius: 20,
                  color: Colors.white,
                  offset: Offset.zero,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
