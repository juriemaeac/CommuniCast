import 'package:flutter/material.dart';

class AppColors {
  static const white = Colors.white;
  static const black = Color(0xFF404040);
  static const grey = Colors.grey;
  static const greyAccent = Color(0xffF0F0F0);
  static const greyAccentLine = Color.fromARGB(255, 218, 218, 218);

  static const blueAccent = Color(0xFF00004d);
}

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  static const subtitle = TextStyle(
    fontSize: 16,
  );
  static const body = TextStyle(
    fontSize: 14,
  );
  static const body1 = TextStyle(
    fontSize: 10,
  );
  static const body2 = TextStyle(
    fontSize: 12,
  );
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
