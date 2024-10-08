import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:krishi_setu/firebase_options.dart';
import 'package:krishi_setu/services/auth_services.dart';

Future<void> setupFirbase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> registerServices() async{
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());
}