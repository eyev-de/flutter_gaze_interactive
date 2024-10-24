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

// pointer: color (GazePointerType.passive)
class GazeInteractivePointerColorPassiveLocalNotifier extends LocalStoreNotifier<String> {
  GazeInteractivePointerColorPassiveLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveGazePointerColorPassive', gazeInteractiveDefaultPointerColorPassive);
}

// pointer: color (GazePointerType.active)
class GazeInteractivePointerColorActiveLocalNotifier extends LocalStoreNotifier<String> {
  GazeInteractivePointerColorActiveLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveGazePointerColorActive', gazeInteractiveDefaultPointerColorActive);
}

// pointer: opacity
class GazeInteractivePointerOpacityLocalNotifier extends LocalStoreNotifier<double> {
  GazeInteractivePointerOpacityLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveGazePointerOpacity', gazeInteractiveDefaultPointerOpacity);
}

// pointer: size
class GazeInteractivePointerSizeLocalNotifier extends LocalStoreNotifier<double> {
  GazeInteractivePointerSizeLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveGazePointerSize', gazeInteractiveDefaultPointerSize);
}

class GazeInteractiveFixationRadiusLocalNotifier extends LocalStoreNotifier<double> {
  GazeInteractiveFixationRadiusLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveFixationRadius', gazeInteractiveDefaultFixationRadius);
}

class GazeInteractiveSnappingRadiusLocalNotifier extends LocalStoreNotifier<double> {
  GazeInteractiveSnappingRadiusLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveSnappingRadius', gazeInteractiveDefaultSnappingRadius);
}

class GazeInteractiveAfterSnapPauseLocalNotifier extends LocalStoreNotifier<int> {
  GazeInteractiveAfterSnapPauseLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveAfterSnapPause', gazeInteractiveDefaultAfterSnapPauseMS);
}

class GazeInteractiveSnappingTimerLocalNotifier extends LocalStoreNotifier<int> {
  GazeInteractiveSnappingTimerLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveSnappingTimer', gazeInteractiveDefaultSnappingTimerMS);
}

class GazeInteractiveRecoverTimeLocalNotifier extends LocalStoreNotifier<int> {
  GazeInteractiveRecoverTimeLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveRecoverTime', gazeInteractiveDefaultRecoverTime);
}

class GazeInteractiveClickSoundVolumeLocalNotifier extends LocalStoreNotifier<int> {
  GazeInteractiveClickSoundVolumeLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveClickSoundVolume', gazeInteractiveDefaultClickSoundVolume);
}

class GazeInteractiveClickSoundTypeLocalNotifier extends LocalStoreNotifier<String> {
  GazeInteractiveClickSoundTypeLocalNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveClickSoundType', gazeInteractiveDefaultClickSoundType);
}

// factor to increase gaze duration on a button when re-selecting by staying on the button (if reselectable = true)
class GazeInteractiveReselectionAccelerationNotifier extends LocalStoreNotifier<double> {
  GazeInteractiveReselectionAccelerationNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveReselectionAcceleration', gazeInteractiveDefaultReselectionAcceleration);
}

// How often a letter key is reselected including a gazeInteractiveDefaultReselectionAcceleration - Factor
// per repeat by staying on this letter with the gaze pointer (if reselectable = true)
class GazeInteractiveReselectionNumberOfLetterKeysNotifier extends LocalStoreNotifier<int> {
  GazeInteractiveReselectionNumberOfLetterKeysNotifier(SharedPreferences sharedPreferences)
      : super(sharedPreferences, 'gazeInteractiveReselectionNumberOfLetterKeys', gazeInteractiveDefaultReselectionNumberOfLetterKeys);
}
