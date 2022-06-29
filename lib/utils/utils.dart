import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/**
 * gallary에서 image 선택 기능
 * @Param ImageSource
 * @return XFileBase
 * */
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);

  if(_file != null) {
    print(_file.path);
    return _file.readAsBytes();
  }
  print('No image selected');
}

/***
 * SnackBar event
 * @Param String content, BuildContext contex
 * @Return
 *
 * */
showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger
      .of(context)
      .showSnackBar(
      SnackBar(
          content: Text(content)
      )
  );
}