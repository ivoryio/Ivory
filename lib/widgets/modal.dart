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
  bool useSafeArea = false,
  bool useScrollableChild = true,
  bool isDismissible = true,
}) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.white,
    useSafeArea: useSafeArea,
    isDismissible: isDismissible,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    builder: (context) {
      if (!useScrollableChild) {
        return _BottomModalSheetContent(
          content: content,
          title: title,
          textWidget: textWidget,
          showCloseButton: showCloseButton,
          isScrollControlled: isScrollControlled,
          addContentPadding: addContentPadding,
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          addContentPadding ? 24 : 0,
          0,
          addContentPadding ? 24 : 0,
          MediaQuery.of(context).padding.bottom + MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: _BottomModalSheetContent(
          content: content,
          title: title,
          textWidget: textWidget,
          showCloseButton: showCloseButton,
          isScrollControlled: isScrollControlled,
          addContentPadding: addContentPadding,
        ),
      );
    },
  );
}

class _BottomModalSheetContent extends StatelessWidget {
  final Widget? content;
  final String? title;
  final Widget? textWidget;
  final bool showCloseButton;
  final bool isScrollControlled;
  final bool addContentPadding;

  const _BottomModalSheetContent({
    this.content,
    this.title,
    this.textWidget,
    this.showCloseButton = true,
    this.isScrollControlled = true,
    this.addContentPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
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
                    title!,
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
        if (textWidget != null) textWidget!,
        if (content != null) content!,
      ],
    );
  }
}
