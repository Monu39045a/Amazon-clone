import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<File>> imagePicker() async {
  List<File> images = [];
  try {
    FilePickerResult? files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      // allowedExtensions: ['jpg', 'jpeg', 'png', 'avif'], It only works with FileType.custom
    );

    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; ++i) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}
