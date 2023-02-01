//  Gaze Widgets Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

import '../../responsive.dart';
import '../button/button.dart';
import '../button/selection_animation.dart';

enum GazeKeyType {
  none,
  ctrl,
  alt,
  win,
  shift,
  caps,
  enter,
  del,
  tab,
}

class GazeKey extends StatelessWidget {
  static final validCharacters = RegExp(r'^[a-zA-Zäöü]+$');

  final Object content;
  final GazeKeyType type;

  final bool? shift;

  final bool? alt;
  final String? altStr;

  final bool? ctrl;
  final String? ctrlStr;

  final double widthRatio;
  final double heightRatio;

  final void Function(String?, GazeKeyType)? onTap;

  final String route;

  GazeKey({
    Key? key,
    required this.content,
    required this.route,
    this.type = GazeKeyType.none,
    this.widthRatio = 1,
    this.heightRatio = 1,
    this.shift,
    this.alt,
    this.altStr,
    this.ctrl,
    this.ctrlStr,
    this.onTap,
  }) : super(key: key);

  static Widget _buildContent(BuildContext context, Object content, bool? shift) {
    if (content is List) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                content[0],
                style: TextStyle(
                    fontSize: Responsive.getResponsiveValue(
                      forLargeScreen: 18,
                      forMediumScreen: 14,
                      forVeryLargeScreen: 20,
                      context: context,
                    ),
                    color: shift != null
                        ? !shift
                            ? Colors.grey.shade500
                            : Colors.white
                        : Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                content[1],
                style: TextStyle(
                    fontSize: Responsive.getResponsiveValue(
                      forLargeScreen: 18,
                      forMediumScreen: 14,
                      forVeryLargeScreen: 20,
                      context: context,
                    ),
                    color: shift != null
                        ? shift
                            ? Colors.grey.shade500
                            : Colors.white
                        : Colors.white),
              ),
            ],
          ),
        ],
      );
    } else if (content is String) {
      final _switchTo = shift != null && shift && content.length == 1 && validCharacters.hasMatch(content);
      return _spaceOut(Text(
        _switchTo ? content.toUpperCase() : content,
        style: TextStyle(
            fontSize: Responsive.getResponsiveValue(
              forLargeScreen: 18,
              forMediumScreen: 14,
              forVeryLargeScreen: 20,
              context: context,
            ),
            color: Colors.white),
      ));
    } else if (content is IconData) {
      return _spaceOut(Icon(
        content,
        color: Colors.white,
        size: Responsive.getResponsiveValue(
          forVeryLargeScreen: 35,
          forLargeScreen: 25,
          forMediumScreen: 25,
          context: context,
        ),
      ));
    } else {
      return Container();
    }
  }

  static Widget _spaceOut(Widget content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            content,
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _switchTo = shift ?? false;
    final changeColor = _switchTo && (type == GazeKeyType.caps || type == GazeKeyType.shift);
    return Flexible(
      flex: widthRatio.round(),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: GazeButton(
          properties: GazeButtonProperties(
            backgroundColor: changeColor ? Theme.of(context).primaryColor : Colors.grey.shade900,
            borderRadius: BorderRadius.zero,
            innerPadding: const EdgeInsets.all(0),
            child: _buildContent(context, content, shift),
            route: route,
            animationColor: !changeColor ? Theme.of(context).primaryColor : Colors.grey.shade900,
            gazeSelectionAnimationType: GazeSelectionAnimationType.fade,
            reselectable: true,
          ),
          onTap: onTap != null
              ? () {
                  if (content is List) {
                    onTap?.call(_switchTo ? (content as List)[0] : (content as List)[1], type);
                  } else if (content is String) {
                    if (_switchTo) {
                      if ((content as String).length == 1 && validCharacters.hasMatch(content as String)) {
                        onTap?.call((content as String).toUpperCase(), type);
                      } else {
                        onTap?.call(content as String, type);
                      }
                    } else {
                      onTap?.call(content as String, type);
                    }
                  } else if (content == Icons.space_bar) {
                    onTap?.call(' ', type);
                  } else {
                    onTap?.call(null, type);
                  }
                }
              : null,
        ),
      ),
    );
  }
}
