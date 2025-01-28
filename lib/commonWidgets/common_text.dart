import 'package:flutter/material.dart';

import '../constants/common_constants.dart';

class CommonText extends StatefulWidget {
  final String text;
  final String styleFor;

  const CommonText({super.key, required this.text, required this.styleFor});

  @override
  State<CommonText> createState() => _CommonTextState();
}

class _CommonTextState extends State<CommonText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: getTextStyle(widget.styleFor),
    );
  }

  getTextStyle(String styleFor) {
    switch (styleFor) {
      case 'title':
        return const TextStyle(
          color: Color(photomallConnectColour),
          shadows: <Shadow>[
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 8.0,
              color: Color.fromARGB(125, 0, 0, 255),
            ),
          ],
        );
      case 'button':
        return const TextStyle(fontSize:15,color: Color(photomallConnectBgColour));
      case 'card':
        return const TextStyle(fontSize:20,color: Color(photomallConnectColour));
      case 'body':
        return const TextStyle(fontSize: 25,color: Color(photomallConnectColour),);

    }
  }
}
