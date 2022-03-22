import 'package:flutter/material.dart';
import 'package:pokemarvel/views/home.dart';
import 'package:pokemarvel/views/pokemon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Pokemon(),
    );
  }
}
