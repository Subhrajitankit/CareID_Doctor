import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0D000000), // rgba(0, 0, 0, 0.05)
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x265B14B8), // subtle purple glow
      blurRadius: 15,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> floatingNavShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 25, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> modalShadow = [
    BoxShadow(color: Color(0x33000000), blurRadius: 30, offset: Offset(0, -5)),
  ];
}
