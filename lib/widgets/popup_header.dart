import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class BottomPopupHeader extends StatelessWidget {
  final String title;
  final bool? showCloseButton;

  const BottomPopupHeader({
    super.key,
    required this.title,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
          ),
          if (showCloseButton!)
            Container(
                alignment: Alignment.centerRight,
                child: PlatformIconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ))
        ],
      ),
    );
  }
}
