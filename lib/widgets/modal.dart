import 'package:flutter/material.dart';

import '../config.dart';

Future<dynamic> showBottomModal({
  required BuildContext context,
  Widget? content,
  String? title,
  Widget? textWidget,
  bool showCloseButton = true,
  bool isScrollControlled = true,
  bool addContentPadding = true,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    builder: (context) => SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        addContentPadding ? 24 : 0,
        8,
        addContentPadding ? 24 : 0,
        MediaQuery.of(context).padding.bottom + MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ClientConfig.getCustomColors().neutral300,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: addContentPadding ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Expanded(
                    child: Text(
                      title,
                      style: ClientConfig.getTextStyleScheme().heading4,
                    ),
                  )
                else
                  const Spacer(),
                if (showCloseButton)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
          if (title != null || showCloseButton) const SizedBox(height: 24),
          if (textWidget != null) textWidget,
          if (content != null) content,
        ],
      ),
    ),
  );
}
