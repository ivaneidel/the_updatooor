import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:the_updatooor/helpers/random.dart';

part 'data_box.g.dart';

@JsonSerializable()
class DataBox {
  final String id;
  final String url;
  final String path;
  final String name;
  final String prefix;

  DataBox(
    this.id,
    this.url,
    this.path,
    this.name,
    this.prefix,
  );

  factory DataBox.fromJson(Map<String, dynamic> json) =>
      _$DataBoxFromJson(json);

  Map<String, dynamic> toJson() => _$DataBoxToJson(this);

  Future<String?> fetchValue() async {
    try {
      final response = await http.get(Uri.parse(url));
      final keys = path.split(',');
      Map object = json.decode(response.body);
      String? value;
      for (var key in keys) {
        if (object[key] != null) {
          if (key == keys.last) {
            value = '${object[key]}';
          } else {
            object = object[key];
          }
        } else {
          throw 'Malformed object';
        }
      }

      return value;
    } catch (e) {
      // Ignore
    }
    return null;
  }
}
