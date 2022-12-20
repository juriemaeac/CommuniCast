import 'package:flutter/material.dart';

class AppColors {
  static const white = Colors.white;
  static const black = Color(0xFF404040);
  static const grey = Colors.grey;
  static const greyAccent = Color(0xffF0F0F0);
  static const greyAccentLine = Color.fromARGB(255, 218, 218, 218);

  static const blueAccent = Color(0xFF178EDE);
  static const darkblue = Color(0xFF043e7d);
}

class AppTextStyles {
  static const TextStyle headings1 = TextStyle(
    color: AppColors.black,
    fontSize: 30,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );
  static const TextStyle subHeadings = TextStyle(
    color: AppColors.grey,
    fontSize: 13,
    fontFamily: 'Poppins',
  );
  static const TextStyle textFields = TextStyle(
    color: AppColors.black,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    fontFamily: 'Poppins',
  );
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
    color: AppColors.black,
  );
  static const title1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
  static const subtitle = TextStyle(
    fontSize: 16,
    fontFamily: 'Poppins',
  );
  static const body = TextStyle(
    fontSize: 14,
    fontFamily: 'Poppins',
  );
  static const body1 = TextStyle(
    fontSize: 10,
    fontFamily: 'Poppins',
  );
  static const body2 = TextStyle(
    fontSize: 12,
    fontFamily: 'Poppins',
  );
  static const button = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
      color: AppColors.white);
}
