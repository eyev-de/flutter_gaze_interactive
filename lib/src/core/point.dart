//  Gaze Interactive
//
//  Created by the eyeV app dev team.
//  Copyright © eyeV GmbH. All rights reserved.
//

import 'dart:math';

class GazePoint {
  // static const tol = 0.005;
  double x = 0;
  double y = 0;
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  GazePoint({this.x = 0, this.y = 0});

  double slope(GazePoint o) {
    return atan((y - o.y).abs() / (x - o.x).abs()) * (180 / pi);
  }

  double distance(GazePoint p2) {
    return sqrt(pow(x - p2.x, 2) + pow(y - p2.y, 2));
  }

  GazePoint operator +(GazePoint p) {
    return GazePoint(x: x + p.x, y: y + p.y);
  }

  GazePoint operator -(GazePoint p) {
    return GazePoint(x: x - p.x, y: y - p.y);
  }

  GazePoint operator /(double k) {
    return GazePoint(x: x / k, y: y / k);
  }

  GazePoint operator *(double k) {
    return GazePoint(x: x * k, y: y * k);
  }

  // bool operator ==(GazePoint p) {
  //   return (x - p.x).abs() < tol && (y - p.y).abs() < tol;
  // }

  double velocity(GazePoint target) {
    final double dist = distance(target);
    final t = target.timestamp - timestamp;
    return t > 0 ? (dist / t).abs() : 0;
  }
}
