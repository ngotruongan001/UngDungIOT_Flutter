import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String description;

  UserModel({
    required this.description,

  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
  };
}