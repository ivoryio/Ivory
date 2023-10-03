import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:solarisdemo/config.dart';

class IvoryAssetWithBadge extends StatelessWidget {
  final bool isSuccess;
  final Widget childWidget;
  final BadgePosition childPosition;
  const IvoryAssetWithBadge(
      {super.key, required this.childWidget, required this.isSuccess, required this.childPosition});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: getPadding(childPosition),
        child: badges.Badge(
          position: childPosition,
          showBadge: true,
          ignorePointer: false,
          onTap: () {},
          badgeContent: _badgeContent(),
          badgeAnimation: const badges.BadgeAnimation.scale(
            animationDuration: Duration(milliseconds: 750),
            curve: Curves.bounceOut,
          ),
          badgeStyle: const badges.BadgeStyle(
            shape: badges.BadgeShape.circle,
            padding: EdgeInsets.all(0),
            elevation: 0,
          ),
          child: childWidget,
        ),
      ),
    );
  }

  Widget _badgeContent() {
    if (isSuccess) {
      return Container(
        height: 64,
        width: 64,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF00774C)),
        child: Icon(
          Icons.check_rounded,
          color: ClientConfig.getColorScheme().surface,
          size: 52,
        ),
      );
    } else {
      return Container(
        height: 64,
        width: 64,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        child: Icon(
          Icons.close_rounded,
          color: ClientConfig.getColorScheme().surface,
          size: 46,
        ),
      );
    }
  }

  EdgeInsets getPadding(BadgePosition position) {
    double top = 0;
    double end = 0;
    double bottom = 0;
    double start = 0;

    // If the BadgePosition values are negative, add additional padding to the opposite side
    if (position.top != null && position.top! < 0) {
      bottom = position.top!.abs();
    }
    if (position.end != null && position.end! < 0) {
      start = position.end!.abs();
    }
    if (position.bottom != null && position.bottom! < 0) {
      top = position.bottom!.abs();
    }
    if (position.start != null && position.start! < 0) {
      end = position.start!.abs();
    }

    return EdgeInsets.only(
      top: top,
      right: end,
      bottom: bottom,
      left: start,
    );
  }
}
