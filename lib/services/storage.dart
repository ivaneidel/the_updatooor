import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_updatooor/models/data_box.dart';

abstract class Storage {
  static Future<List<DataBox>> fetchDataBoxes() async {
    final boxes = <DataBox>[];
    try {
      final preferences = await SharedPreferences.getInstance();
      final stringBoxes = preferences.getString('data_boxes');
      if (stringBoxes != null) {
        boxes.addAll(
          (json.decode(stringBoxes) as List).map(
            (box) => DataBox.fromJson(box),
          ),
        );
      }
    } catch (e) {
      // Ignore
    }
    return boxes;
  }

  static Future<void> saveDataBox(DataBox dataBox) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final stringBoxes = preferences.getString('data_boxes') ?? '[]';
      final boxes = json.decode(stringBoxes) as List;
      final boxIndex = boxes.indexWhere((box) => box['id'] == dataBox.id);
      if (boxIndex < 0) {
        boxes.add(dataBox.toJson());
      } else {
        boxes[boxIndex] = dataBox.toJson();
      }
      await preferences.setString('data_boxes', json.encode(boxes));
    } catch (e) {
      // Ignore
    }
  }

  static Future<void> saveBoxesOrder(List<DataBox> boxes) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('data_boxes', json.encode(boxes));
    } catch (e) {
      // Ignore
    }
  }

  static Future<void> removeDataBox(DataBox dataBox) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final stringBoxes = preferences.getString('data_boxes') ?? '[]';
      final boxes = json.decode(stringBoxes) as List;
      boxes.removeWhere((box) => box['id'] == dataBox.id);
      await preferences.setString('data_boxes', json.encode(boxes));
    } catch (e) {
      // Ignore
    }
  }
}
