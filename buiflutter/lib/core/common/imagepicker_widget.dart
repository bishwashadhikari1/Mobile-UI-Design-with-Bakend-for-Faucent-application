import 'dart:io';

import 'package:flutter/material.dart';

Widget imagePickerWidget(context, _imageFile, _pickImage) {
  return Column(children: [
    Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: _imageFile != null
          ? Image.file(
              File(_imageFile!.path),
              fit: BoxFit.cover,
              width: double.infinity,
            )
          : Text(
              'No Image Selected',
              textAlign: TextAlign.center,
            ),
      alignment: Alignment.center,
    ),
    ElevatedButton.icon(
      icon: Icon(Icons.image),
      label: Text('Select Image'),
      onPressed: _pickImage,
    ),
  ]);
}
