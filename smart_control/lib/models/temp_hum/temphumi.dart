
import 'package:json_annotation/json_annotation.dart';
part 'temphumi.g.dart';

@JsonSerializable(explicitToJson: true)
class TempHumi {
  TempHumi(this.tempC, this.humi);
  double tempC;
  double humi;
  factory TempHumi.fromJson(Map<String, dynamic> json) =>
      _$TempHumiFromJson(json);
  Map<String, dynamic> toJson() => _$TempHumiToJson(this);
}