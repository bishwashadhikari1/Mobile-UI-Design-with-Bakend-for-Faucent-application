import 'package:flutter/material.dart';

showSnackBar(BuildContext context, message, {Color color = Colors.green}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      content: Text('$message'),
      duration: const Duration(seconds: 1),
    ),
  );
}
