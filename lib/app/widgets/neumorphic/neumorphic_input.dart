import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

class NeumoInput extends StatelessWidget {
  final EdgeInsets padding;

  final Widget child;

  final double borderRadius;

  NeumoInput({
    this.padding,
    this.child,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      color: Theme.of(context).backgroundColor,
      emboss: true,
      borderRadius: borderRadius ?? 15,
      curveType: CurveType.concave,
      depth: 15,
      spread: 2,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(15.0),
        child: child,
      ),
    );
  }
}
