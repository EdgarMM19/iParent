import 'package:flutter/material.dart';
import 'todoList.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MyMama',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final double padding = 25;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: padding, vertical: padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("MyMama",
                      style: TextStyle(
                          fontSize: 72.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal)),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: padding, vertical: padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [TodoList()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
