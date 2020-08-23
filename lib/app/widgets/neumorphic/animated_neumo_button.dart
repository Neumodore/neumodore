import 'package:flutter/material.dart';

import 'neumo_button.dart';

class FadedNeumoButton extends StatelessWidget {
  final EdgeInsets padding;
  final Icon child;
  final VoidCallback onPressed;

  FadedNeumoButton({
    this.onPressed,
    this.padding,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeIn,
      duration: Duration(seconds: 1),
      child: child,
      builder: (ctx, val, child) => Opacity(
        opacity: val * 1,
        child: NeumoButton(
          child: child ?? Icon(Icons.error_outline),
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          onPressed: onPressed ?? () {},
        ),
      ),
    );
  }
}
