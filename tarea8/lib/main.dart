import 'package:flutter/material.dart';
import 'tabscontrol.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: const TabsControl(),
        // Esto sirve para esconder la etiqueta de modo de depuración.
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.red,
            appBarTheme: const AppBarTheme(color: Colors.red)));
  }
}
