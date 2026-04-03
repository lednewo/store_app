import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/profile/view_model/profile_cubit.dart';
import 'package:base_app/presentation/profile/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileCubit _cubit = AppInjector.inject.get<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.loadProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is ProfileLoggedOut) {
          context.pushReplacement(AppRoutes.login);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final profile = state.profile;
          return Scaffold(
            appBar: AppBar(title: Text(l10n.profileTitle)),
            floatingActionButton: profile.userType.toUpperCase() == 'VENDEDOR'
                ? FloatingActionButton.extended(
                    onPressed: () {
                      context.push(AppRoutes.createProduct);
                    },
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addProductButton),
                  )
                : null,
            body: SafeArea(
              child: ListView(
                children: [
                  Container(
                    width: double.infinity,
                    color: colorScheme.primaryContainer,
                    padding: const EdgeInsets.symmetric(
                      vertical: 36,
                      horizontal: 24,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: colorScheme.primary,
                          child: Text(
                            profile.name.isNotEmpty
                                ? profile.name[0].toUpperCase()
                                : '?',
                            style: textTheme.displaySmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          profile.name,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(
                            profile.userType,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.profileInfoSectionLabel,
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          margin: EdgeInsets.zero,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.email_outlined,
                                  color: colorScheme.primary,
                                ),
                                title: Text(
                                  l10n.profileEmailLabel,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  profile.email,
                                  style: textTheme.bodyMedium,
                                ),
                                visualDensity: VisualDensity.comfortable,
                              ),
                              const Divider(height: 1, indent: 56),
                              ListTile(
                                leading: Icon(
                                  Icons.phone_outlined,
                                  color: colorScheme.primary,
                                ),
                                title: Text(
                                  l10n.profilePhoneLabel,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  profile.phone,
                                  style: textTheme.bodyMedium,
                                ),
                                visualDensity: VisualDensity.comfortable,
                              ),
                              const Divider(height: 1, indent: 56),
                              ListTile(
                                leading: Icon(
                                  Icons.location_on_outlined,
                                  color: colorScheme.primary,
                                ),
                                title: Text(
                                  l10n.profileAddressLabel,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  profile.address,
                                  style: textTheme.bodyMedium,
                                ),
                                visualDensity: VisualDensity.comfortable,
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(
                                  right: 16,
                                  top: 8,
                                  bottom: 16,
                                ),
                                child: TextButton(
                                  onPressed: () async {
                                    await _cubit.logout();
                                  },
                                  child: Text('Sair'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            body: SafeArea(
              child: Center(child: Text(state.message)),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
