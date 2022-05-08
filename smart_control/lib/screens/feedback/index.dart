import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_control/constants/theme_data.dart';
import 'package:smart_control/models/user_model.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

//url: https://server-flutter2-ktm.herokuapp.com/

Future<UserModel?> createUser(String description ) async{
  final String apiUrl = "https://server-flutter2-ktm.herokuapp.com/v1/api/message/create";

  final response = await http.post(apiUrl, body: {
    "description": description,
  });

  if(response.statusCode == 200){
    final String responseString = response.body;

    return userModelFromJson(responseString);
  }else{
    return null;
  }
}

class _ReportPageState extends State<ReportPage> {
  final myController = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback"),
        backgroundColor: CustomColors.menuBackgroundColor,
      ),
      backgroundColor: CustomColors.pageBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/feedback-2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: myController,
                style: TextStyle(
                  color: CustomColors.primaryTextColor
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      //post
                      //....
                      final UserModel? user = await createUser(myController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                    myController.text = "";
                  },
                  child: Center(
                      child: Container(
                          height: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[Text('Submit',style: TextStyle(
                              color: CustomColors.primaryTextColor
                            ),)],))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
}