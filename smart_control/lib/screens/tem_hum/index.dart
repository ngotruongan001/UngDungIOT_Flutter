import 'dart:convert';
import "package:flutter/material.dart";
import 'package:smart_control/constants/theme_data.dart';
import 'package:smart_control/models/temp_hum/temphumi.dart';
import 'package:web_socket_channel/io.dart';


const String esp_url = 'nhập IP và Port';

class TemparaturePage extends StatefulWidget {
  const TemparaturePage({Key? key}) : super(key: key);

  @override
  _TemparaturePageState createState() => _TemparaturePageState();
}

class _TemparaturePageState extends State<TemparaturePage> {
  var temperature = 0;
  var humidity = 0;
   var msg = '';
  TempHumi dht = TempHumi(0, 0);
  final channel = IOWebSocketChannel.connect(esp_url);
  @override
  void initState() {
    super.initState();
    channel.stream.listen(
          (message) {
        if (message == "Dont connected") {
          print("Error");
        } else {
          print('Received from MCU: $message');
          Map<String, dynamic> json = jsonDecode(message);
          setState(() {
            dht = TempHumi.fromJson(json);
          });
        }
        //channel.sink.close(status.goingAway);
      },
      onDone: () {
        //if WebSocket is disconnected
        print("Web socket is closed");
        setState(() {
          msg = 'disconnected';
        });
      },
      onError: (error) {
        print(error.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right:20.0),
      child: Column(
        children: [
          //tem
          SizedBox(
            height: 30,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.loose,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                'Temperature & Humidity',
                style: TextStyle(
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w700,
                    color: CustomColors.primaryTextColor,
                    fontSize: 23),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: (){
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ListCharts("Temperature",0)),
              // );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              height: 180,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      dht.tempC <= 25
                          ? "assets/images/cold.jpg"
                          : dht.tempC >= 30
                          ?"assets/images/hot.jpg"
                          :"assets/images/normally.jpg"

                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30, left: 20),
                        child: Column(
                          children: [
                            const Text(
                              "Temperature",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '${dht.tempC.toStringAsFixed(1)} °C',
                              style: const TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                    child: Image(
                      image: AssetImage(
                          dht.tempC <= 25
                              ?'assets/icon/temperature_2.png'
                              : dht.tempC >= 30
                              ?'assets/icon/temperature_1.png'
                              : 'assets/icon/normally.png'
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //hum
          GestureDetector(
            // onTap: (){
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => ListCharts("Humidity",1)),
            //   );
            // },
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              height: 180,
              decoration: BoxDecoration(
                // color: Colors.blue,
                image: const DecorationImage(
                  image: AssetImage("assets/images/humidyti.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30, left: 20),
                        child: Column(
                          children: [
                            const Text(
                              "Humidity",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '${dht.humi.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 100,
                    child: Image(
                      image: AssetImage(
                          'assets/icon/humidity.png'
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
