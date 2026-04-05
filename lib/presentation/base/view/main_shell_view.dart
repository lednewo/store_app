import 'package:base_app/common/utils/login_detect.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/dashboard/view/dashboard_tab_content.dart';
import 'package:base_app/presentation/products/view/cart/view/cart_view.dart';
import 'package:base_app/presentation/products/view/products_view.dart';
import 'package:base_app/presentation/profile/view_model/profile_cubit.dart';
import 'package:base_app/presentation/profile/view_model/profile_state.dart';
import 'package:base_app/presentation/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainShellView extends StatefulWidget {
  const MainShellView({super.key});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  final ProfileCubit _profileCubit = AppInjector.inject.get<ProfileCubit>();
  int _currentIndex = 0;
  final _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _profileCubit.loadProfile();

    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  void jump(int i) {
    setState(() {
      _currentIndex = i;
      _pageController.jumpToPage(i);
    });
  }

  List<Widget> _buildTabs(LoginType type) {
    final pagesList = <Widget>[];

    if (type == LoginType.vendedor) {
      pagesList.add(const DashboardTabContent());
    }
    pagesList.add(const ProductsView());
    if (type == LoginType.cliente) {
      pagesList.add(const CartView());
    }
    pagesList.add(const ProfileView());
    return pagesList;
  }

  List<BottomNavigationBarItem> _buildNavItems(LoginType type) {
    final itemsList = <BottomNavigationBarItem>[];

    if (type == LoginType.vendedor) {
      itemsList.add(
        BottomNavigationBarItem(
          icon: const Icon(Icons.dashboard_outlined),
          activeIcon: const Icon(Icons.dashboard),
          label: context.l10n.dashboardTitle,
        ),
      );
    }

    itemsList.addAll([
      BottomNavigationBarItem(
        icon: const Icon(Icons.store_outlined),
        activeIcon: const Icon(Icons.store),
        label: context.l10n.productsTabLabel,
      ),

      if (LoginDetect.isCliente)
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Carrinho',
        ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person_outline),
        activeIcon: const Icon(Icons.person),
        label: context.l10n.profileTitle,
      ),
    ]);

    return itemsList;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: _profileCubit,
      builder: (context, state) {
        if (state is ProfileInitial || state is ProfileLoading) {
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

        if (state is ProfileLoaded) {
          return ValueListenableBuilder<LoginType>(
            valueListenable: LoginDetect.loginTypeNotifier,
            builder: (context, loginType, _) {
              if (!LoginDetect.isVendedor && loginType == LoginType.vendedor) {
                return Scaffold(
                  body: SafeArea(
                    child: Center(child: Text(l10n.unauthorizedMessage)),
                  ),
                );
              }

              final navItems = _buildNavItems(loginType);
              final safeIndex = _currentIndex.clamp(0, navItems.length - 1);
              if (safeIndex != _currentIndex) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _currentIndex = safeIndex;
                      _pageController.jumpToPage(safeIndex);
                    });
                  }
                });
              }

              return Scaffold(
                body: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _buildTabs(loginType),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: safeIndex,
                  onTap: jump,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Theme.of(context).colorScheme.primary,
                  unselectedItemColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: .6),
                  items: navItems,
                ),
              );
            },
          );
        }

        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }
}
