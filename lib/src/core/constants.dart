//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'package:flutter/material.dart';

const gazeInteractiveDefaultDuration = 1800;
const gazeInteractiveMinDuration = 400; // Not validated
const gazeInteractiveMaxDuration = 2000; // Not validated

const gazeInteractiveDefaultScrollFactor = 80.0;
const gazeInteractiveMinScrollFactor = 40.0; // Not validated
const gazeInteractiveMaxScrollFactor = 120.0; // Not validated

const gazeInteractiveDefaultRecoverTime = 3000;
const gazeInteractiveMinRecoverTime = 1500; // Not validated
const gazeInteractiveMaxRecoverTime = 3000; // Not validated

const gazeInteractiveDefaultClickSoundVolume = 5;
const gazeInteractiveDefaultClickSoundType = 'Typewriter';

/// Gaze Pointer Settings
const gazeInteractiveDefaultPointerColorPassive = 'FFBF6E'; // Colors.yellow
const gazeInteractiveDefaultPointerColorActive = 'AD1457'; // Colors.pink

const gazeInteractiveDefaultPointerOpacity = 0.6;
const gazeInteractiveMinPointerOpacity = 0.2;
const gazeInteractiveMaxPointerOpacity = 1.0;

const gazeInteractiveDefaultPointerSize = 55.0;
const gazeInteractiveMinPointerSize = 10.0; // Not validated
const gazeInteractiveMaxPointerSize = 70.0; // Not validated

const gazeInteractiveDefaultFixationRadius = 100.0;
const gazeInteractiveMinFixationRadius = 80.0; // Not validated
const gazeInteractiveMaxFixationRadius = 120.0; // Not validated

const gazeInteractiveDefaultSnappingRadius = 20.0;
const gazeInteractiveMinSnappingRadius = 2.0; // Not validated
const gazeInteractiveMaxSnappingRadius = 60.0; // Not validated

const gazeInteractiveDefaultAfterSnapPauseMS = 2000;
const gazeInteractiveMinAfterSnapPauseMS = 0; // Not validated
const gazeInteractiveMaxAfterSnapPauseMS = 40000; // Not validated

const gazeInteractiveDefaultSnappingTimerMS = 2000;
const gazeInteractiveMinSnappingTimerMS = 0; // Not validated
const gazeInteractiveMaxSnappingTimerMS = 40000; // Not validated

const gazeInteractiveDefaultReselectionAcceleration = 0.75;
const gazeInteractiveReselectionMinAcceleration = 0.4; // Not validated
const gazeInteractiveReselectionMaxAcceleration = 0.9; // Not validated

const gazeInteractiveDefaultReselectionNumberOfLetterKeys = 2;
const gazeInteractiveMinReselectionNumberOfLetterKeys = 1; // Not validated
const gazeInteractiveMaxReselectionNumberOfLetterKeys = 5; // Not validated

const timeToIgnorePointerWhenSnappingMs = 200; // needed especially for mouse usage

const deleteButtonColor = Color(0xFFAD1457);
const deleteButtonTextColor = Colors.white;
const textDisabledColor = Color(0x80ffffff);
const tealColor = Color(0xFFACE0D4);
const surfaceColor = Color(0xFF012D35);
const disabledBaseButtonColor = Color(0xFF091E23);
