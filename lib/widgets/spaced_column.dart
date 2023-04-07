import 'package:flutter/material.dart';

class SpacedColumn extends Column {
  final double space;
  SpacedColumn({
    Key? key,
    required this.space,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    List<Widget> children = const <Widget>[],
  }) : super(
          key: key,
          children: [
            for (final child in children)
              Column(
                children: [
                  child,
                  SizedBox(height: space),
                ],
              ),
          ],
        );
}
