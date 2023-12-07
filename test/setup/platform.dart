import 'package:flutter/foundation.dart';

void setPlatformOverride(TargetPlatform platform) {
  debugDefaultTargetPlatformOverride = platform;
}

void resetPlatformOverride() {
  debugDefaultTargetPlatformOverride = null;
}
