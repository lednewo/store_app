import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/presentation/auth/views/login_view.dart';
import 'package:base_app/presentation/auth/views/register_view.dart';
import 'package:base_app/presentation/base/view/main_shell_view.dart';
import 'package:base_app/presentation/products/view/cart/view/cart_view.dart';
import 'package:base_app/presentation/products/view/product_info_view.dart';
import 'package:base_app/presentation/profile/views/create_product/view/create_product_view.dart';
import 'package:base_app/presentation/profile/views/orders/view/order_details_view.dart';
import 'package:base_app/presentation/profile/views/orders/view/orders_view.dart';
import 'package:base_app/presentation/profile/views/profile_view.dart';
import 'package:base_app/presentation/splash/view/splash_view.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainShellView(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: AppRoutes.createProduct,
      builder: (context, state) => const CreateProductView(),
    ),
    GoRoute(
      path: AppRoutes.productDetails,
      builder: (context, state) {
        final args = state.extra! as String;
        return ProductInfoView(productId: args);
      },
    ),
    GoRoute(
      path: AppRoutes.cart,
      builder: (context, state) => const CartView(),
    ),
    GoRoute(
      path: AppRoutes.orders,
      builder: (context, state) => const OrdersView(),
    ),
    GoRoute(
      path: AppRoutes.orderDetails,
      builder: (context, state) {
        final args = state.extra! as String;
        return OrderDetailsView(orderId: args);
      },
    ),
  ],
);
