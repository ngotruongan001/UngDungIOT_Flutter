// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temphumi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TempHumi _$TempHumiFromJson(Map<String, dynamic> json) => TempHumi(
  (json['tempC'] as num).toDouble(),
  (json['humi'] as num).toDouble(),
);

Map<String, dynamic> _$TempHumiToJson(TempHumi instance) => <String, dynamic>{
  'tempC': instance.tempC,
  'humi': instance.humi,
};