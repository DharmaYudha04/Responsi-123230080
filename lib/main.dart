import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/meal.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/favorite_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MealAdapter());
  await Hive.openBox<Meal>(FavoriteService.boxName);

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final username = prefs.getString('username') ?? '';

  runApp(MyApp(isLoggedIn: isLoggedIn, username: username));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String username;

  const MyApp({super.key, required this.isLoggedIn, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kamus Makanan Sak Duniyo | Responsi Mobile | 123230080',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: isLoggedIn ? HomePage(username: username) : const LoginPage(),
    );
  }
}
