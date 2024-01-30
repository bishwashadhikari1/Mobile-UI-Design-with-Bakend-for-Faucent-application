import 'package:flutter/material.dart';
import 'package:talab/config/theme/app_color_constant.dart';

Widget elevatedButtonWidget(String btnText, onPressed) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorConstant.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(btnText,
          style: const TextStyle(
              fontSize: 16, color: Colors.white, fontFamily: "sf-medium")),
    ),
  );
}
