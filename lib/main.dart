import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nftcommerce/authentication/register.dart';
import 'package:url_strategy/url_strategy.dart';

import 'authentication/login.dart';

void main() async {
  setPathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
      title: 'ART_ECOMMERCE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
