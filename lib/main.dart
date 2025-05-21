import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ukl_produktif/views/login_view.dart';
import 'package:ukl_produktif/views/matkul_view.dart';
import 'package:ukl_produktif/views/profile_view.dart';
import 'package:ukl_produktif/views/register_nasabah_bank.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginView(),
        '/register': (context) => const RegisterView(),
        '/profile': (context) => const ProfileView(),
        '/matkul': (context) => const MatkulView(),

        
      },
    );
  }
}
