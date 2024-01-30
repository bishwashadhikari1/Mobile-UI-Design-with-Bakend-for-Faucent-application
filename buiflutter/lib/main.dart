import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/app.dart';
import 'package:flutter/material.dart';
import 'package:talab/core/network/local/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const ProviderScope(
    //     child: App(),
    //   ),
    // ),
    const ProviderScope(
      child: App(),
    ),
  );
}
