import 'package:flutter/material.dart';
import 'package:learn_http/models/login_model.dart';
import 'package:learn_http/pages/detail_page.dart';
import 'package:learn_http/pages/home_page.dart';
import 'package:learn_http/pages/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.amber);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(LoginAdapter());
  await Hive.openBox('authBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('authBox');
    var token = box.get('token');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
      ),
      home: token == null ? const LoginPage() : const MyHomePage(),
      routes: {
        MyHomePage.id: (context) => const MyHomePage(),
        DetailPage.id: (context) => const DetailPage(),
      },
    );
  }
}
