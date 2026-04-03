import 'dart:async';

import 'package:base_app/common/widgets/app_snackbar.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/auth/view_model/register_cubit.dart';
import 'package:base_app/presentation/auth/view_model/register_state.dart';
import 'package:base_app/presentation/auth/widgets/register_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterCubit _cubit = AppInjector.inject.get<RegisterCubit>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<RegisterCubit, RegisterState>(
            bloc: _cubit,
            listener: (context, state) {
              if (state is RegisterSuccess) {
                AppSnackbar.showSuccess(context, message: state.message);
                context.go(AppRoutes.login);
              }

              if (state is RegisterError) {
                AppSnackbar.showError(context, message: state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is RegisterLoading;

              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withValues(
                              alpha: 0.08,
                            ),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(
                              Icons.storefront_rounded,
                              size: 56,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.registerTitle,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.registerSubtitle,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 32),
                            RegisterFormWidget(
                              isLoading: isLoading,
                              onSubmit:
                                  ({
                                    required String name,
                                    required String email,
                                    required String password,
                                    required String phone,
                                    required String address,
                                  }) {
                                    return _cubit.register(
                                      name: name,
                                      email: email,
                                      password: password,
                                      phone: phone,
                                      address: address,
                                    );
                                  },
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => context.go(AppRoutes.login),
                              child: Text(l10n.registerLoginLink),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
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
