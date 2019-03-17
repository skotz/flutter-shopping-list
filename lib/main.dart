import 'package:flutter/material.dart';
import 'store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StorePage(title: 'Flutter Shopping List'),
    );
  }
}