import 'dart:async';

import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/presentation/splash/view_model/splash_cubit.dart';
import 'package:base_app/presentation/splash/view_model/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashCubit _cubit = AppInjector.inject.get<SplashCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_cubit.initialize());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SplashCubit, SplashState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is SplashNavigateToHome) {
              context.go(AppRoutes.home);
            }

            if (state is SplashNavigateToLogin) {
              context.go(AppRoutes.login);
            }
          },
          builder: (context, state) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }
}
