//  Gaze Widgets Lib
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:shared_preferences/shared_preferences.dart';

import 'local_store_notifier.dart';

class GazeInteractiveDurationLocalNotifier extends LocalStoreNotifier<int> {
  GazeInteractiveDurationLocalNotifier(SharedPreferences sharedPreferences) : super(sharedPreferences, 'gazeInteractiveDuration', 1800);
}

class GazeInteractiveScrollFactorLocalNotifier extends LocalStoreNotifier<double> {
  GazeInteractiveScrollFactorLocalNotifier(SharedPreferences sharedPreferences) : super(sharedPreferences, 'gazeInteractiveScrollFactor', 80);
}

class GazeInteractivePointerSizeLocalNotifier extends LocalStoreNotifier<double> {
  GazeInteractivePointerSizeLocalNotifier(SharedPreferences sharedPreferences) : super(sharedPreferences, 'gazeInteractiveGazePointerSize', 50);
}

class GazeInteractiveFixationRadiusLocalNotifier extends LocalStoreNotifier<double> {
  GazeInteractiveFixationRadiusLocalNotifier(SharedPreferences sharedPreferences) : super(sharedPreferences, 'gazeInteractiveFixationRadius', 100);
}

class GazeInteractiveRecoverTimeLocalNotifier extends LocalStoreNotifier<int> {
  GazeInteractiveRecoverTimeLocalNotifier(SharedPreferences sharedPreferences) : super(sharedPreferences, 'gazeInteractiveRecoverTime', 3000);
}
