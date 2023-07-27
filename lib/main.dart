import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_catalogue_mvp_getx/screens/home/home_binding.dart';
import 'package:movie_catalogue_mvp_getx/screens/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Movie Catalogue',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF090F32),
        ),
        // primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF090F32),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomeScreen(),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}
