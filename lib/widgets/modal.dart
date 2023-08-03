import 'package:flutter/material.dart';

Future<void> showBottomModal({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = false,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (_) => child,
  );
}
