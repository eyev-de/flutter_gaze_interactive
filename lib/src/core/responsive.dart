//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/widgets.dart';

class Responsive {
  static const maxWidth = 1920 * 4;
  static const maxHeight = 1080 * 4;
  static EdgeInsets padding(BuildContext context, EdgeInsets base) {
    // final media = MediaQuery.of(context);
    // final heightFactor = media.size.height / maxHeight;
    // final widthFactor = media.size.width / maxWidth;
    // return EdgeInsets.fromLTRB(base.left * widthFactor, base.top * heightFactor, base.right * widthFactor, base.bottom * heightFactor);
    return getResponsiveValue(
      forVeryLargeScreen: base,
      forLargeScreen: base / 1.5,
      forMediumScreen: base / 2.0,
      context: context,
    );
  }

  static T getResponsiveValue<T>({
    required T forLargeScreen,
    T? forVeryLargeScreen,
    T? forSmallScreen,
    T? forMediumScreen,
    T? forMobLandScapeMode,
    T? forTabletScreen,
    required BuildContext context,
  }) {
    if (isLargeScreen(context)) {
      return forLargeScreen;
    } else if (isVeryLargeScreen(context)) {
      return forVeryLargeScreen ?? forLargeScreen;
    } else if (isMediumScreen(context)) {
      return forMediumScreen ?? forLargeScreen;
    } else if (isTabletScreen(context)) {
      return forTabletScreen ?? forMediumScreen ?? forLargeScreen;
    } else if (isSmallScreen(context) && isLandScapeMode(context)) {
      return forMobLandScapeMode ?? forLargeScreen;
    } else {
      return forSmallScreen ?? forLargeScreen;
    }
  }

  static bool isLandScapeMode(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return true;
    } else {
      return false;
    }
  }

  static bool isVeryLargeScreen(BuildContext context) {
    return getWidth(context) >= 1600 && getHeight(context) >= 900;
  }

  static bool isLargeScreen(BuildContext context) {
    return getWidth(context) >= 1366 && getWidth(context) < 1600 || getHeight(context) >= 770 && getHeight(context) < 900;
  }

  static bool isSmallScreen(BuildContext context) {
    return getWidth(context) <= 800 || getHeight(context) < 560;
  }

  static bool isMediumScreen(BuildContext context) {
    return getWidth(context) > 800 && getWidth(context) < 1366 || getHeight(context) >= 560 && getHeight(context) < 770;
  }

  static bool isTabletScreen(BuildContext context) {
    return getWidth(context) > 450 && getWidth(context) < 800;
  }

  static double getWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width;
  }

  static double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return height;
  }
}
