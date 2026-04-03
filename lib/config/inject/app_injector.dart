import 'package:base_app/common/services/database/app_persistence.dart';
import 'package:base_app/common/services/database/app_persistence_impl.dart';
import 'package:base_app/common/services/http/dio_http_service.dart';
import 'package:base_app/common/services/http/http_service.dart';
import 'package:base_app/common/services/in_app_purchase/in_app_purchase_service.dart';
import 'package:base_app/common/services/shared_preferences_service.dart';
import 'package:base_app/common/services/storage_service.dart';
import 'package:base_app/common/utils/app_logger_detect_service.dart';
import 'package:base_app/config/network/dio_client.dart';
import 'package:base_app/data/datasources/auth/auth_datasource.dart';
import 'package:base_app/data/datasources/auth/auth_local_datasource.dart';
import 'package:base_app/data/datasources/auth/auth_local_datasource_impl.dart';
import 'package:base_app/data/datasources/order/order_datasource.dart';
import 'package:base_app/data/datasources/products/products_datasource.dart';
import 'package:base_app/data/repositories/auth_repository_impl.dart';
import 'package:base_app/data/repositories/orders_repository_impl.dart';
import 'package:base_app/data/repositories/products_repository_impl.dart';
import 'package:base_app/domain/interfaces/auth_repository.dart';
import 'package:base_app/domain/interfaces/order_repository.dart';
import 'package:base_app/domain/interfaces/products_repository.dart';
import 'package:base_app/presentation/auth/view_model/login_cubit.dart';
import 'package:base_app/presentation/auth/view_model/register_cubit.dart';
import 'package:base_app/presentation/products/view/cart/view_model/cart_cubit.dart';
import 'package:base_app/presentation/products/view_model/products_cubit.dart';
import 'package:base_app/presentation/profile/view_model/profile_cubit.dart';
import 'package:base_app/presentation/profile/views/create_product/view_model/create_product_cubit.dart';
import 'package:base_app/presentation/profile/views/orders/view_model/orders_cubit.dart';
import 'package:base_app/presentation/splash/view_model/splash_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

enum AppFlavor { development, staging, production }

class AppInjector {
  static GetIt inject = GetIt.instance;

  static Future<void> setupDependencies({
    required AppFlavor flavor,
  }) async {
    // Registra o flavor para acesso global
    inject.registerLazySingleton<AppFlavor>(() => flavor);

    // Configuração baseada no flavor
    final baseUrl = _getBaseUrlForFlavor(flavor);
    final enableLogs = _shouldEnableLogsForFlavor(flavor);

    inject
      ..registerLazySingleton<StorageService>(
        SharedPreferencesService.new,
      )
      ..registerLazySingleton<AppPersistence>(
        AppPersistenceImpl.new,
      )
      // Network - Dio (privado)
      ..registerLazySingleton<Dio>(
        () => makeDio(
          appPersistence: inject(),
          baseUrl: baseUrl,
          enableLogs: enableLogs,
        ),
      )
      // HttpService (abstração pública)
      ..registerLazySingleton<HttpService>(
        () => DioHttpService(inject()),
      )
      ..registerLazySingleton<AppLoggerService>(AppLoggerService.new)
      // DataSources
      ..registerLazySingleton<AuthDatasource>(
        () => AuthDatasource(httpService: inject()),
      )
      ..registerLazySingleton<AuthLocalDatasource>(
        () => AuthLocalDatasourceImpl(inject()),
      )
      ..registerLazySingleton<ProductsDatasource>(
        () => ProductsDatasource(httpService: inject()),
      )
      ..registerLazySingleton<OrderDatasource>(
        () => OrderDatasource(httpService: inject()),
      )
      // Repositories
      ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          authDatasource: inject(),
          authLocalDatasource: inject(),
        ),
      )
      ..registerLazySingleton<ProductsRepository>(
        () => ProductsRepositoryImpl(productsDatasource: inject()),
      )
      ..registerLazySingleton<OrderRepository>(
        () => OrdersRepositoryImpl(orderDatasource: inject()),
      )
      // Services
      ..registerLazySingleton<InAppPurchaseService>(
        InAppPurchaseService.new,
      )
      // Cubits
      ..registerFactory<LoginCubit>(
        () => LoginCubit(inject()),
      )
      ..registerFactory<RegisterCubit>(
        () => RegisterCubit(inject()),
      )
      ..registerFactory<ProductsCubit>(
        () => ProductsCubit(repository: inject()),
      )
      ..registerFactory<ProfileCubit>(
        () => ProfileCubit(inject()),
      )
      ..registerFactory<SplashCubit>(
        () => SplashCubit(inject()),
      )
      ..registerFactory<CreateProductCubit>(
        () => CreateProductCubit(inject()),
      )
      // CartCubit é singleton para manter o estado do carrinho entre telas
      ..registerLazySingleton<CartCubit>(
        () => CartCubit(inject()),
      )
      ..registerFactory<OrdersCubit>(
        () => OrdersCubit(inject()),
      );
  }

  static String _getBaseUrlForFlavor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.development:
        return 'http://192.168.1.9:8080/api';
      case AppFlavor.staging:
        return 'https://staging-api.example.com';
      case AppFlavor.production:
        return 'http://192.168.1.9:8080/api';
    }
  }

  static bool _shouldEnableLogsForFlavor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.development:
      case AppFlavor.staging:
        return true;
      case AppFlavor.production:
        return false;
    }
  }
}
