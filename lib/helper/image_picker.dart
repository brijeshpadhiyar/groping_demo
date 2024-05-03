import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> imagePicker() async {
  File? image;
  XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (file != null) {
    image = File(file.path);
  }
  return image;
}
