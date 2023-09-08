import 'package:flutter/material.dart';

import '../config.dart';

class TextMessageWithCircularImage extends StatelessWidget {
  final String title;
  final String message;

  const TextMessageWithCircularImage({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 133,
            height: 133,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF747474),
            ),
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                size: 65,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Text(
            title,
            style: ClientConfig.getTextStyleScheme().heading2,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
        ],
      ),
    );
  }
}
