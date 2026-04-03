import 'package:base_app/app.dart';
import 'package:base_app/bootstrap.dart';
import 'package:base_app/config/app_initializer.dart';
import 'package:base_app/config/inject/app_injector.dart';

Future<void> main() async {
  await AppInitializer.initialize(AppFlavor.production);
  await bootstrap(() => const App());
}
