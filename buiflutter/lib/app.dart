import 'package:flutter/material.dart';
import 'package:talab/config/theme/app_themes.dart';
import 'package:talab/config/router/app_route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getApplicationTheme(),
      title: 'Talab',
      initialRoute: AppRoute.splashScreenRoute,
      routes: AppRoute.getAppRoutes(),
    );
  }
}
