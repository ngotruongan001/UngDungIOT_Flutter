import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_control/constants/theme_data.dart';
import 'package:smart_control/screens/details/circle_progress.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  bool isLoading = false;
  var temperature = 0.0;
  var humidity = 0.0;
  late AnimationController progressController;
  late Animation<double> tempAnimation;
  late Animation<double> humidityAnimation;

  late Timer timer;
  @override
  void initState() {
    super.initState();
    //callApi();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => callApi());
    _DashboardInit(temperature, humidity);
  }
  void callApi() {
    getNewsData();
  }
  var url1 = "Nhập API";
  getNewsData() async  {
    var response = await http.get(Uri.parse(url1));

    var _newTemperature= 0.0;
    var _newHumidity= 0.0;

    if(response.statusCode == 200){
      // var m = jsonDecode(response.body)["field1"]["feeds"];
      List m = jsonDecode(response.body)['feeds'];
      _newTemperature =  double.parse(m[m.length - 1]["field1"]);
      _newHumidity = double.parse(m[m.length - 1]["field2"]);
      print(m);
    }else{
      _newTemperature = 0.0;
      _newHumidity = 0.0;
    }

    setState((){
      temperature= _newTemperature;
      humidity = _newHumidity;
      isLoading = true;

    });
  }

  _DashboardInit(double temperature, double humidity) async {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000)); //5s

    tempAnimation =
    Tween<double>(begin: -50, end: temperature).animate(progressController)
      ..addListener(() {
        setState(() {});
      });

    humidityAnimation =
    Tween<double>(begin: 0, end: humidity).animate(progressController)
      ..addListener(() {
        setState(() {});
      });

    progressController.forward();
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Home Temp & Humi',
                  style: TextStyle(
                      fontFamily: 'avenir',
                      fontWeight: FontWeight.w700,
                      color: CustomColors.primaryTextColor,
                      fontSize: 24),
                ),
              ),
            ),
            CustomPaint(
              foregroundPainter: CircleProgress(temperature, true),
              child: Container(
                width: 200,
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Temperature',
                        style: TextStyle(
                            color: CustomColors.primaryTextColor
                        ),
                      ),
                      Text(
                        '${temperature}',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold,
                            color: CustomColors.primaryTextColor
                        ),
                      ),
                      Text(
                        '°C',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primaryTextColor
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomPaint(
              foregroundPainter: CircleProgress(humidity, false),
              child: Container(
                width: 200,
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Humidity',
                        style: TextStyle(
                            color: CustomColors.primaryTextColor
                        ),
                      ),
                      Text(
                        '${humidity}',
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primaryTextColor

                        ),
                      ),
                      Text(
                        '%',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.primaryTextColor
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

}
