import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

class NeumoButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;

  const NeumoButton({
    Key key,
    this.backgroundColor,
    this.onPressed,
    this.padding,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeuButton(
      onPressed: onPressed,
      padding: padding ?? EdgeInsets.all(20),
      child: child,
      decoration: NeumorphicDecoration(
        color: backgroundColor ?? Theme.of(context).backgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
