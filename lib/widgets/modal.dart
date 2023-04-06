import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Future<void> showBottomModal({
  required BuildContext context,
  required Widget child,
}) async {
  await showPlatformModalSheet(
    context: context,
    material: MaterialModalSheetData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    ),
    builder: (_) => child,
  );
}
