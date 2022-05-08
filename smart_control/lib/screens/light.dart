import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_control/constants/theme_data.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketLed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WebSocketLed();
  }
}
class _WebSocketLed extends State<WebSocketLed> {
  late bool ledstatus; //boolean value to track LED status, if its ON or OFF
  late IOWebSocketChannel channel;
  late bool connected; //boolean value to track if WebSocket is connected
  late int leddata = 0;
  @override
  void initState() {
    ledstatus = false; //initially leadstatus is off so its FALSE
    connected = false; //initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });

    super.initState();
  }

  channelconnect() {
    //function to connect
    try {
      channel = IOWebSocketChannel.connect(
          "ws://192.168.99.100:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          print(message);
          setState(() {
            if (message == "connected") {
              connected = true; //message is "connected" from NodeMCU
            } else if (message == "poweron:success") {
              ledstatus = true;
            } else if (message == "poweroff:success") {
              ledstatus = false;
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      if (ledstatus == false && cmd != "poweron" && cmd != "poweroff") {
        print("Send the valid command");
      } else {
        channel.sink.add(cmd); //sending Command to NodeMCU
      }
    } else {
      channelconnect();
      print("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          // alignment: Alignment.topCenter, //inner widget alignment to center
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    'Control Light',
                    style: TextStyle(
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w700,
                        color: CustomColors.primaryTextColor,
                        fontSize: 24),
                  ),
                ),
              ),

              // Container(
              //     child: ledstatus
              //         ? Text("LED IS: ON",
              //             style:
              //                 TextStyle(color: CustomColors.primaryTextColor))
              //         : Text("LED IS: OFF",
              //             style:
              //                 TextStyle(color: CustomColors.primaryTextColor))),
              SingleChildScrollView(

                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50,),
                        Container(
                          child: (ledstatus == true)
                              ? SizedBox(width: 150, child: Image.asset("assets/icon/on.png"))
                              : SizedBox(
                              width: 150, child: Image.asset("assets/icon/off.png")),
                        ),
                        SizedBox(height: 40,),
                        Center(
                          child: Container(
                              child: connected
                                  ? Text(
                                "CONNECTED",
                                style:
                                TextStyle(
                                    fontFamily: 'avenir',
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.primaryTextColor,
                                    fontSize: 18),
                              )
                                  : Text("DISCONNECTED",
                                style:
                                TextStyle(
                                    fontFamily: 'avenir',
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.primaryTextColor,
                                    fontSize: 18),)),
                        ),
                        SizedBox(height: 30),
                        Container(
                          margin: EdgeInsets.only(top:30),
                          child: Center(
                            child: Transform.rotate(
                              angle: 0,
                              child: Transform.scale(
                                scale: 3.5,
                                child: Switch(
                                  value: ledstatus,
                                  onChanged: (value) {
                                    if (ledstatus) {
                                      //if ledstatus is true, then turn off the led
                                      //if led is on, turn off
                                      sendcmd("poweroff");
                                      ledstatus = false;
                                      leddata = 0;
                                      final DatabaseReference _database = FirebaseDatabase().reference();
                                      _database.child('ESP32_Device/Led').set({"status": leddata});
                                    } else {
                                      //if ledstatus is false, then turn on the led
                                      //if led is off, turn on
                                      sendcmd("poweron");
                                      ledstatus = true;
                                      leddata = 1;
                                      final DatabaseReference _database = FirebaseDatabase().reference();
                                      _database.child('ESP32_Device/Led').set({"status": leddata});
                                    }
                                    setState(
                                      () {},
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
            ],
          )),
    );
  }
}
