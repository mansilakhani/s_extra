import 'package:flutter/material.dart';
import 'package:sql_rev/views/screens/homepage.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => const HomePage(),

      //'/': (context) => MyApp()
    },
  ));
}
