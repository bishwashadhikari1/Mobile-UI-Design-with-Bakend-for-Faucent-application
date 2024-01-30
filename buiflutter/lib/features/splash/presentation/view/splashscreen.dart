import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talab/config/router/app_route.dart';

import '../../../auth/presentation/viewmodel/auth_viewmodel.dart';

class TalabSplash extends ConsumerStatefulWidget {
  const TalabSplash({super.key});

  @override
  ConsumerState<TalabSplash> createState() => _TalabSplashState();
}

class _TalabSplashState extends ConsumerState<TalabSplash> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    await ref.read(authViewModelProvider.notifier).loginWithToken();
    final authState = ref.watch(authViewModelProvider);
    if (authState.loggedUser == null) {
      Navigator.pushNamed(context, AppRoute.welcomePage);
    } else {
      Navigator.pushNamed(context, AppRoute.dashboardRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
