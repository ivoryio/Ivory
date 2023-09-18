import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IvoryColorMapper implements ColorMapper {
  const IvoryColorMapper({
    required this.baseColor,
    this.accentColor,
  });

  static const _rawBaseColor = Color(0xFF2575FC);
  static const _rawAccentColor = Color(0xFF2575FC);

  final Color baseColor;
  final Color? accentColor;

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    if (color == _rawBaseColor) return baseColor;

    final accentColor = this.accentColor;
    if (accentColor != null && color == _rawAccentColor) return accentColor;

    return color;
  }
}