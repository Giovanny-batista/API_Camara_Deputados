import 'package:flutter/material.dart';
import 'package:parliament/routes/router.dart' as routes;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      onGenerateRoute: routes.controller,
      initialRoute: routes.home,
      debugShowCheckedModeBanner: false,
    );
  }
}