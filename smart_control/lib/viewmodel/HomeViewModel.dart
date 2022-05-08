import 'dart:convert';

import 'package:flutter/cupertino.dart';


class HomeViewModel extends ChangeNotifier{
  bool backgroundDark = true;

  ChangeBackground()  {
    backgroundDark = !backgroundDark;

    notifyListeners();
  }

}