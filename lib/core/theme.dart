import 'package:flutter/material.dart';

abstract final class MarnieColors {
  static const paper = Color(0xfff2f2f2),
      ink = Color(0xff222222),
      muted = Color(0xff888888),
      line = Color(0xffcccccc),
      image = Color(0xffe7e7e7),
      pink = Color(0xffcd3c7c);
}

TextStyle display(double size, {Color? color}) => TextStyle(
  fontFamily: 'Playfair Display',
  fontSize: size,
  height: 1.23,
  color: color,
);
TextStyle label([double size = 16, Color? color]) => TextStyle(
  fontFamily: 'Bebas Neue',
  fontSize: size,
  height: 1.4,
  letterSpacing: 1.05,
  color: color,
);
TextStyle caption([double size = 11, Color? color]) => TextStyle(
  fontFamily: 'Montserrat',
  fontSize: size,
  height: 1.6,
  letterSpacing: 1.5,
  color: color ?? MarnieColors.muted,
);

ThemeData marnieTheme(bool dark) {
  final ink = dark ? MarnieColors.paper : MarnieColors.ink;
  final base = dark ? ThemeData.dark() : ThemeData.light();
  return base.copyWith(
    scaffoldBackgroundColor: dark ? MarnieColors.ink : MarnieColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: MarnieColors.ink,
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: ink,
      surface: dark ? MarnieColors.ink : MarnieColors.paper,
    ),
    textTheme: base.textTheme.apply(
      fontFamily: 'Montserrat',
      bodyColor: ink,
      displayColor: ink,
    ),
    iconTheme: IconThemeData(color: ink, size: 23),
    dividerTheme: const DividerThemeData(
      color: MarnieColors.line,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: caption(13, const Color(0xffaaaaaa)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: MarnieColors.line, width: 1.5),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ink, width: 1.5),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ink,
      contentTextStyle: TextStyle(
        color: dark ? MarnieColors.ink : Colors.white,
        fontFamily: 'Montserrat',
      ),
    ),
  );
}
