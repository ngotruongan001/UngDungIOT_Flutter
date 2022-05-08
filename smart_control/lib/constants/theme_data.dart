import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CustomColors extends ChangeNotifier {
  bool mainBgHome = true;

  static Color primaryTextColor = Colors.white;
  static Color dividerColor = Colors.white54;
  static Color pageBackgroundColor = Color(0xFF2D2F41);
  static Color menuBackgroundColor = Color(0xFF242634);

  static Color clockBG = Color(0xFF444974);
  static Color clockOutline = Color(0xFFEAECFF);
  static Color? secHandColor = Colors.orange[300];
  static Color minHandStatColor = Color(0xFF748EF6);
  static Color minHandEndColor = Color(0xFF77DDFF);
  static Color hourHandStatColor = Color(0xFFC279FB);
  static Color hourHandEndColor = Color(0xFFEA74AB);

  updateBg(bool _check) {
    if(_check){
      pageBackgroundColor = Color(0xFF2D2F41);
      primaryTextColor = Colors.white;
      dividerColor = Colors.white54;

      clockOutline = Color(0xFFEAECFF);
      secHandColor = Colors.orange[300];

    }else{
      pageBackgroundColor = Colors.white;
      primaryTextColor = Color(0xFF2D2F41);
      dividerColor = Colors.black54;

      clockBG = Color(0xFF444974);
      clockOutline = Color(0xFF242634);


    }

    mainBgHome = _check;
    notifyListeners();
  }

}

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];
  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.mango),
    GradientColors(GradientColors.fire),
  ];
}