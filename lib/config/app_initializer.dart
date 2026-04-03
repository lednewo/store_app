import 'package:base_app/config/inject/app_injector.dart';
import 'package:flutter/widgets.dart';
import 'package:verify_local_purchase/verify_local_purchase.dart';

class AppInitializer {
  static Future<void> initialize(AppFlavor flavor) async {
    // Inicializações comuns que são sempre necessárias
    WidgetsFlutterBinding.ensureInitialized();

    // Outras inicializações que podem ser adicionadas aqui:
    // await Firebase.initializeApp();
    // await SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp
    // ]);
    // await Hive.initFlutter();

    VerifyLocalPurchase.initialize(
      appleConfig: AppleConfig(
        bundleId: 'xxxxx',
        issuerId: 'xxxxx',
        keyId: 'xxxxx',
        privateKey: 'xxxxx', // AppBytes.decryptPrivateKey(),
      ),
      googlePlayConfig: GooglePlayConfig(
        packageName: 'xxxxx',
        serviceAccountJson: 'xxxxx', // AppBytes.decrypt(),
      ),
    );

    // Setup das dependências com o flavor específico
    await AppInjector.setupDependencies(flavor: flavor);
  }
}
