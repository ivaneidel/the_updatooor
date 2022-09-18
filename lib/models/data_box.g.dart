// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataBox _$DataBoxFromJson(Map<String, dynamic> json) => DataBox(
      json['url'] as String,
      json['path'] as String,
      json['name'] as String,
      json['prefix'] as String,
    );

Map<String, dynamic> _$DataBoxToJson(DataBox instance) => <String, dynamic>{
      'url': instance.url,
      'path': instance.path,
      'name': instance.name,
      'prefix': instance.prefix,
    };
