import 'package:flutter/material.dart';

class AppColor {
  static const Color backColor = Colors.white;
  static const Color mainColor = Color(0xFF600CAC);
  static const Color mainColorLight = Color(0xFF8E41D5);
  static const Color mainColorMegaLight = Color(0xFFA168D5);
  static const Color mainColorDark = Color(0xFF3C0470);
  static const Color green = Color(0xFF74E600);
  static const Color orange = Color(0xFFFFAD00);
  static const Color orangeLight = Color(0xFFFFC140);
  static const Color orangeMegaLight = Color(0xFFFFD273);
  static const Color greyDark = Color(0xFF999999);
  static const Color greyMedium = Color(0xFF8E8E8E);
  static const Color greyLight = Color(0xFFD9D9D9);
  static const Color greyMegaLight = Color(0xFFEAEAEA);
  static const Color error = Color(0xFFE95255);
}

ThemeData _themeLight = ThemeData.light();

ThemeData themeLight = _themeLight.copyWith(
  colorScheme: _schemeLight(_themeLight.colorScheme),
  appBarTheme: _appBarLight(_themeLight.appBarTheme),
  bottomNavigationBarTheme:
      _botNavBarLight(_themeLight.bottomNavigationBarTheme),
  elevatedButtonTheme: ElevatedButtonThemeData(style: _elevButtonLight),
  textButtonTheme: TextButtonThemeData(style: _textButtonLight),
  outlinedButtonTheme: OutlinedButtonThemeData(style: _outButtonLight),
  chipTheme: _chipLight(_themeLight.chipTheme),
  primaryColorDark: AppColor.mainColor,
  textTheme: _textLight(_themeLight.textTheme),
  scaffoldBackgroundColor: AppColor.backColor,
  floatingActionButtonTheme:
      _floatButtonLight(_themeLight.floatingActionButtonTheme),
  inputDecorationTheme: _inputDecorLight(_themeLight.inputDecorationTheme),
);

ColorScheme _schemeLight(ColorScheme base) {
  return base.copyWith(
    error: AppColor.error,
    primary: AppColor.backColor,
    onPrimary: AppColor.mainColor,
    primaryContainer: AppColor.mainColor,
  );
}

TextTheme _textLight(TextTheme base) {
  return base.copyWith(
    headlineMedium: base.headlineMedium!.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: AppColor.backColor,
    ),
    headlineLarge: base.headlineMedium!.copyWith(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColor.backColor,
    ),
    bodyMedium: base.bodyMedium!.copyWith(
      fontSize: 14,
      fontFamily: 'Open Sans',
    ),
    bodySmall: base.bodySmall!.copyWith(
      fontSize: 11,
      fontFamily: 'Open Sans',
      color: Colors.black,
    ),
    labelSmall: base.labelSmall!.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      fontFamily: 'Open Sans',
      letterSpacing: 0,
    ),
    labelMedium: base.labelMedium!.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColor.mainColor,
      fontFamily: 'Montserrat',
    ),
    titleSmall: base.titleSmall!.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat',
    ),
    titleMedium: base.titleMedium!.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat',
    ),
    titleLarge: base.titleLarge!.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: 'Montserrat',
    ),
  );
}

FloatingActionButtonThemeData _floatButtonLight(
    FloatingActionButtonThemeData base) {
  return base.copyWith(
    backgroundColor: AppColor.orange,
    foregroundColor: Colors.black,
  );
}

AppBarTheme _appBarLight(AppBarTheme base) {
  return base.copyWith(
    backgroundColor: AppColor.backColor,
    centerTitle: false,
    foregroundColor: AppColor.mainColor,
    elevation: 0.0,
  );
}

BottomNavigationBarThemeData _botNavBarLight(
    BottomNavigationBarThemeData base) {
  return base.copyWith(
    backgroundColor: AppColor.backColor,
    selectedItemColor: AppColor.mainColor,
    unselectedItemColor: AppColor.greyDark,
    selectedIconTheme: const IconThemeData(color: AppColor.mainColor),
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: const TextStyle(fontSize: 12),
  );
}

ButtonStyle _elevButtonLight = ElevatedButton.styleFrom(
  backgroundColor: AppColor.mainColor,
  foregroundColor: Colors.white,
  textStyle: const TextStyle(fontSize: 20, fontFamily: 'Open Sans'),
  padding: const EdgeInsets.all(16),
);

ButtonStyle _outButtonLight = ElevatedButton.styleFrom(
  foregroundColor: AppColor.mainColor,
  textStyle: const TextStyle(
      fontWeight: FontWeight.w500, fontSize: 16, fontFamily: 'Montserrat'),
  padding: const EdgeInsets.all(16),
);

ButtonStyle _textButtonLight = ElevatedButton.styleFrom(
  foregroundColor: AppColor.mainColor,
  textStyle: const TextStyle(
      fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'Montserrat'),
  padding: const EdgeInsets.all(16),
);

ChipThemeData _chipLight(ChipThemeData base) {
  return base.copyWith(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    showCheckmark: false,
    padding: const EdgeInsets.all(8),
    backgroundColor: Colors.white,
    selectedColor: Colors.white,
    labelStyle: TextStyle(
        color: MaterialStateColor.resolveWith(
      (Set<MaterialState> states) => states.contains(MaterialState.selected)
          ? AppColor.mainColor
          : AppColor.greyDark,
    )),
  );
}

InputDecorationTheme _inputDecorLight(InputDecorationTheme base) {
  return base.copyWith(
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.mainColor)),
  );
}
