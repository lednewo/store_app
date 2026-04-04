import 'package:base_app/common/utils/extensions/text_words_extension.dart';
import 'package:base_app/common/utils/login_detect.dart';
import 'package:base_app/common/widgets/app_button.dart';
import 'package:base_app/common/widgets/app_dialog.dart';
import 'package:base_app/common/widgets/app_snackbar.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/domain/entities/profile_entity.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/profile/view_model/profile_cubit.dart';
import 'package:base_app/presentation/profile/view_model/profile_state.dart';
import 'package:base_app/presentation/profile/widgets/update_profile_sheet.dart';
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

  Future<void> _onShowBottomSheetUpdateProfile({
    required ProfileEntity profile,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UpdateProfileSheet(
        profile: profile,
        onConfirm: _cubit.updateProfile,
      ),
    );
  }

  Future<void> _onShowLogoutDialog() async {
    final l10n = context.l10n;
    final result = await AppDialog.show(
      title: l10n.logoutDialogTitle,
      context: context,
      description: l10n.logoutDescription,
      confirmLabel: l10n.yesButton,
      cancelLabel: l10n.noButton,
    );
    if (result == true) {
      await _cubit.logout();
    }
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
        if (state is ProfileUpdateSuccess) {
          AppSnackbar.showSuccess(context, message: state.message);
          _cubit.loadProfile();
        }
        if (state is ProfileUpdateError) {
          AppSnackbar.showError(context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final profile = state.profile;
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.profileTitle),
              centerTitle: true,
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _cubit.loadProfile();
                },
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
                                    profile.phone.phoneFormatter(),
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
                                Card(
                                  margin: EdgeInsets.zero,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.receipt_long_outlined,
                                      color: colorScheme.primary,
                                    ),
                                    title: Text(
                                      LoginDetect.isVendedor
                                          ? l10n.ordersLabel
                                          : l10n.ordersTitle,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () => context.push(AppRoutes.orders),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            label: l10n.updateProfileButton,
                            onTap: () => _onShowBottomSheetUpdateProfile(
                              profile: profile,
                            ),
                            isFullWidth: true,
                            variant: AppButtonVariant.secondary,
                          ),
                          const SizedBox(height: 12),
                          if (LoginDetect.isVendedor) ...[
                            AppButton(
                              label: l10n.addProductButton,
                              onTap: () =>
                                  context.push(AppRoutes.createProduct),
                              isFullWidth: true,
                            ),
                            const SizedBox(height: 12),
                          ],
                          AppButton(
                            label: l10n.logoutButton,
                            variant: AppButtonVariant.destructive,
                            onTap: _onShowLogoutDialog,
                            isFullWidth: true,
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
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
