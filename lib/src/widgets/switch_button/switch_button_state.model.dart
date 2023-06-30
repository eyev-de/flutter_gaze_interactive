//  Gaze Interactive
//
//  Created by Konstantin Wachendorff.
//  Copyright © eyeV GmbH. All rights reserved.
//
import 'package:freezed_annotation/freezed_annotation.dart';

part 'switch_button_state.model.freezed.dart';

@freezed
class GazeSwitchButtonState with _$GazeSwitchButtonState {
  factory GazeSwitchButtonState({
    required bool toggled,
    @Default(false) bool gazeInteractive,
  }) = _GazeSwitchButtonState;

  GazeSwitchButtonState._();
}
