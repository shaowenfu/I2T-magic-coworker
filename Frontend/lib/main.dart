import 'package:flutter/material.dart';
import 'constants/app_constants.dart';
import 'pages/welcome/welcome_page.dart';
import 'pages/main_navigation.dart';
import 'common/services_locator.dart';
import 'services/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  await UserService().loadUserInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}



// 忧郁的小女孩带着连衣帽孤独地在商业街步行街雨中低头走路，视角是从小女孩对面的步行街