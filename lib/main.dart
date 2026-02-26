import 'package:flutter/material.dart';

import 'game_page.dart';

void main() {
  runApp(const IPayApp());
}

class IPayApp extends StatelessWidget {
  const IPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'I-Pay 終極密碼',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}
