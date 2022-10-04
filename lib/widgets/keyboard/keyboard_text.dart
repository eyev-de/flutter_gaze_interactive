//  Gaze Widgets Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import 'state.dart';

class GazeKeyboardTextWidget extends StatefulWidget {
  final GazeKeyboardState state;

  GazeKeyboardTextWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GazeKeyboardTextWidgetState();
}

class _GazeKeyboardTextWidgetState extends State<GazeKeyboardTextWidget> {
  late String text;
  late String placeholder;

  @override
  void initState() {
    super.initState();
    widget.state.controller.addListener(_listenToController);
    text = widget.state.controller.text;
    placeholder = widget.state.placeholder;
  }

  void _listenToController() {
    setState(() {
      text = widget.state.controller.text;
    });
  }

  @override
  void dispose() {
    widget.state.controller.removeListener(_listenToController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Container(
        color: Colors.grey.shade900,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            text == '' ? placeholder : text,
            style: text == '' ? const TextStyle(fontSize: 25, color: Colors.grey) : const TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
