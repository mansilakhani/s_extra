import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class Students {
  final int id;
  final String name;
  final int age;
  final String city;
  final Uint8List image;

  Students({
    required this.id,
    required this.name,
    required this.city,
    required this.age,
    required this.image,
  });

  factory Students.fromMap(Map<String, dynamic> data) {
    return Students(
      id: data['id'],
      name: data['name'],
      city: data['city'],
      age: data['age'],
      image: data['image'],
    );
  }
}

/// ValidatorInsert globals ...
String? name;
int? age;
String? city;
Uint8List? image;

final ImagePicker picker = ImagePicker();

// /// UpdateValidator globals ...
//
// String? updatename;
// int? updateage;
// String? updatecity;
// Uint8List? updateimage;
