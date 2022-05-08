
import 'package:smart_control/models/enum.dart';
import 'package:smart_control/models/menu_info.dart';

List<MenuInfo> menuItems = [
  MenuInfo(MenuType.clock,
      title: 'Clock', imageSource: 'assets/images/clock.png'),
  MenuInfo(MenuType.light,
      title: 'Light', imageSource: 'assets/images/light.png'),
  MenuInfo(MenuType.temperature,
      title: 'Temp', imageSource: 'assets/images/temperature.png'),
  MenuInfo(MenuType.temperatureHome,
      title: 'Temp-Home', imageSource: 'assets/images/home_temperature.png'),
  // MenuInfo(MenuType.chatbot,
  //     title: 'ChatBot', imageSource: 'assets/images/chatbot.png'),
];
