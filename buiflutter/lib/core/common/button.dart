import 'package:flutter/material.dart';

Widget elebutton(String text, Function() onPressed) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 36),
      ),
      child: Text(text));
}
