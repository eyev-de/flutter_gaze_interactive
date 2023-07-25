//  Gaze Widgets Lib
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'local_store_notifier.dart';

class GazeInteractiveDurationLocalNotifier extends LocalStoreNotifier<int> {
  GazeInteractiveDurationLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveDuration', gazeInteractiveDefaultDuration);
}

class GazeInteractiveScrollFactorLocalNotifier extends LocalStoreNotifier<double> {
  GazeInteractiveScrollFactorLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveScrollFactor', gazeInteractiveDefaultScrollFactor);
}

class GazeInteractivePointerSizeLocalNotifier extends LocalStoreNotifier<double> {
  GazeInteractivePointerSizeLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveGazePointerSize', gazeInteractiveDefaultPointerSize);
}

class GazeInteractiveFixationRadiusLocalNotifier extends LocalStoreNotifier<double> {
  GazeInteractiveFixationRadiusLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveFixationRadius', gazeInteractiveDefaultFixationRadius);
}

class GazeInteractiveRecoverTimeLocalNotifier extends LocalStoreNotifier<int> {
  GazeInteractiveRecoverTimeLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveRecoverTime', gazeInteractiveDefaultRecoverTime);
}
