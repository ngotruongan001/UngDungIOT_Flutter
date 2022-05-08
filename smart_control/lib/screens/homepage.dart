import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';
import 'package:smart_control/constants/theme_data.dart';
import 'package:smart_control/models/data.dart';
import 'package:smart_control/models/enum.dart';
import 'package:smart_control/models/menu_info.dart';
import 'package:smart_control/screens/chat_bot/ChatBot.dart';
import 'package:smart_control/screens/clock_page.dart';
import 'package:smart_control/screens/feedback/index.dart';
import 'package:smart_control/screens/light.dart';
import 'package:smart_control/screens/map/maps_screen.dart';
import 'package:smart_control/screens/tem_hum/index.dart';
import 'package:smart_control/screens/temp_home/dash_board.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {//lỗi firebase
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CustomColors>.withConsumer(
        viewModelBuilder: () => CustomColors(),
        builder: (context, model, child) => Scaffold(
          backgroundColor: CustomColors.pageBackgroundColor,
          body: Row(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: menuItems
                          .map((currentMenuInfo) => buildMenuButton(
                          currentMenuInfo, model.mainBgHome))
                          .toList(),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: CustomColors.pageBackgroundColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapsScreen()),
                        );
                      },
                      child: Column(children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 64,
                          width: 55,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/map.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Map',
                          style: TextStyle(
                            color: model.mainBgHome
                                ? CustomColors.primaryTextColor
                                : Colors.black,
                            fontFamily: 'avenir',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: CustomColors.pageBackgroundColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatBot(model)),
                        );
                      },
                      child: Column(children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 64,
                          width: 64,
                          decoration: const BoxDecoration(

                            image: DecorationImage(
                              image: AssetImage('assets/images/chatbot.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'ChatBot',
                          style: TextStyle(
                            color: model.mainBgHome
                                ? CustomColors.primaryTextColor
                                : Colors.black,
                            fontFamily: 'avenir',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: CustomColors.pageBackgroundColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportPage()),
                        );
                      },
                      child: Column(children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 64,
                          width: 64,
                          decoration: const BoxDecoration(

                            image: DecorationImage(
                              image: AssetImage('assets/images/feedback.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Feedback',
                          style: TextStyle(
                            color: model.mainBgHome
                                ? CustomColors.primaryTextColor
                                : Colors.black,
                            fontFamily: 'avenir',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              VerticalDivider(
                color: CustomColors.dividerColor,
                width: 1,
              ),
              Expanded(
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: model.mainBgHome
                                ? Colors.black
                                : Colors.black26,
                          ),
                          onPressed: () {
                            model.updateBg(true);
                          },
                          child: Text(
                            'Dark',
                            style: TextStyle(
                              color: model.mainBgHome
                                  ? Colors.white
                                  : Colors.white24,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: !model.mainBgHome
                                ? Colors.white
                                : Colors.white24,
                          ),
                          onPressed: () {
                            model.updateBg(false);
                          },
                          child: Text(
                            'Light',
                            style: TextStyle(
                              color: !model.mainBgHome
                                  ? Colors.black
                                  : Colors.black26,
                            ),
                          ),
                        ),
                      ]),
                  Expanded(
                    child: Consumer<MenuInfo>(
                      builder: (BuildContext context, MenuInfo value,
                          Widget child) {
                        if (value.menuType == MenuType.clock) {
                          return ClockPage();
                        }
                        if (value.menuType == MenuType.light) {
                          return  WebSocketLed();
                        }
                        if (value.menuType == MenuType.temperature) {
                          return const TemparaturePage();
                        }
                        if (value.menuType == MenuType.temperatureHome) {
                          return Dashboard();
                        } else {
                          return RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 20),
                              children: <TextSpan>[
                                const TextSpan(text: 'Upcoming Tutorial\n'),
                                TextSpan(
                                  text: value.title,
                                  style: const TextStyle(fontSize: 48),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ));
  }

  Widget buildMenuButton(MenuInfo currentMenuInfo, bool check) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child) {
        return FlatButton(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(32))),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
          color: currentMenuInfo.menuType == value.menuType
              ? (check ? CustomColors.menuBackgroundColor : Colors.black12)
              : Colors.transparent,
          onPressed: () {
            var menuInfo = Provider.of<MenuInfo>(context, listen: false);
            menuInfo.updateMenu(currentMenuInfo);
          },
          child: Column(
            children: <Widget>[
              Image.asset(
                currentMenuInfo.imageSource,
                scale: 1.5,
              ),
              const SizedBox(height: 16),
              Text(
                currentMenuInfo.title,
                style: TextStyle(
                    fontFamily: 'avenir',
                    color: CustomColors.primaryTextColor,
                    fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}