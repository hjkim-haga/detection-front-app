import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imagePath = 's1.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple playback'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Click me!'),
          onPressed: () {
            Image image = Image.file(
              File(imagePath),
              width: 100,
              height: 100,
            );
            print('width: ${image.width}, height: ${image.height}');
          },
        ),
      ),
    );
  }
}
