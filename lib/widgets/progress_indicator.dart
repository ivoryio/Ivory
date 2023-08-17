import 'package:flutter/material.dart';

class IvoryProgressIndicator extends StatelessWidget {
  IvoryProgressIndicatorPages pages;
  IvoryProgressIndicator({
    super.key,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(4),
      child: LinearProgressIndicator(
        value: pages.pageNumber / pages.numberOfPages,
        color: const Color(0xFFCC0000),
        backgroundColor: const Color(0xFFE9EAEB),
      ),
    );
  }
}

class IvoryProgressIndicatorPages {
  final int pageNumber;
  final int numberOfPages;

  const IvoryProgressIndicatorPages({
    required this.pageNumber,
    required this.numberOfPages,
  });
}
