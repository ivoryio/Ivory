import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  // required String title,
  required String message,
  String? defaultActionText,
  required Function()? onOkPressed,
}) async {
  await showPlatformDialog(
    context: context,
    builder: (_) => PlatformAlertDialog(
      content: Text(message),
      // title: Text(title),
      actions: [
        // cancel button
        // PlatformDialogAction(
        //   child: Text(cancelActionText),
        //   onPressed: () => Navigator.pop(context),
        // ),
        PlatformDialogAction(
          onPressed: onOkPressed,
          child: Text(defaultActionText ?? "OK"),
        ),
      ],
    ),
  );
}
