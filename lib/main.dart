import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const AgrixoApp());
}

class AgrixoApp extends StatelessWidget {
  const AgrixoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agrixo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(), // 🔥 CONNECTED HERE
    );
  }
}
