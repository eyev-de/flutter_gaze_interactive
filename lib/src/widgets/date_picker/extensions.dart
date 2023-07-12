//  Gaze Widgets Lib
//
//  Created by the eyeV App Dev Team.
//  Copyright © eyeV GmbH. All rights reserved.
//

extension DateOnlyCompare on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }
}
