import 'package:flutter/material.dart';
import 'package:neumodore/widgets/neumorphic/neu_progress_circle.dart';
import 'package:neumorphic/neumorphic.dart';

class ShowcaseScreen extends StatefulWidget {
  @override
  _ShowcaseScreenState createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  Color backgroundColor = false ? Color(0xFFefeeee) : Color(0xFF1c1f27);

  @override
  Widget build(BuildContext context) {
    Widget content;

    content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NeuProgressCircle(
              backgroundColor: backgroundColor,
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Neumodore',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            content,
          ],
        ),
      ),
    );
  }
}
