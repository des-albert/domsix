import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Domino Double Six Assistant',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(
              144, 224, 238, 0.25) // Set background color here
      ),

      home: const DominoForm(),
    );
  }
}

class DominoForm extends StatefulWidget {
  const DominoForm({super.key});

  @override
  State<DominoForm> createState() => _DominoFormState();
}

class _DominoFormState extends State<DominoForm> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('DB\'r Domino Solver'),
          foregroundColor: Colors.lightBlueAccent,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(14, 110, 140, 0.5)),

      body: const Column ( children: [
        Divider(
          height: 10,
          thickness: 0,
          indent: 5,
          endIndent: 5,
        ),

      ],

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
