import 'package:dicoding_flutter_project/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: MediaQuery.of(context).platformBrightness,
      ),
      home: const MainPage(),
    );
  }
}
