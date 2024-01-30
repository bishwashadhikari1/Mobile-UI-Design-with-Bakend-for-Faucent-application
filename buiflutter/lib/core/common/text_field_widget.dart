import 'package:flutter/material.dart';
import 'package:talab/config/theme/app_color_constant.dart';

Widget textFieldWidget(String name, TextEditingController controller) {
  // );
  return TextFormField(
      controller: controller,
      style: const TextStyle(
        color: AppColorConstant.black,
        fontFamily: "sf-medium",
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: name,
        // filled: true,
        // fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // Grey border for normal state
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // Grey border for enabled state
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // Grey border for focused state
          borderRadius: BorderRadius.circular(8),
        ),
      ));
}
