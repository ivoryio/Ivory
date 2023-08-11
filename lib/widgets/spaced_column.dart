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
            for (var i = 0; i < children.length - 1; i++) ...[
              children[i],
              SizedBox(height: space),
            ],
            children.last,
          ],
        );
}
