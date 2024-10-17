import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike Race Game',
      debugShowCheckedModeBanner: false,  // Disable the debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bike Race Game'),
        ),
        body: Center(
          child: Image.asset('assets/bike.png'),
        ),
      ),
    );
  }
}
