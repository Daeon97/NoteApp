import 'package:flutter/material.dart';

class AppStyle {
  static const bgColor = Color(0xFFe2e2ff);
  static const mainColor = Color(0xFFF7F7F7);
  static const accentColor = Color(0xFF0065ff);

  static List<Color> cardColors = [
    Colors.blue[100]!,
    Colors.indigo[100]!,
    Colors.pink[100]!,
    Colors.yellow[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!,
    Colors.grey[400]!,
  ];

  static TextStyle mainTitle = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle mainContent = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle date = const TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle textButton = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle appBarText = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle smallBlackText = const TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle blackText14 = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle blackText17 = const TextStyle(
      fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle blackText15 = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
}
