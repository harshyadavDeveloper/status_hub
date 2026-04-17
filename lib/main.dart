import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/template_provider.dart';
import 'providers/editor_provider.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TemplateProvider()),
        ChangeNotifierProvider(create: (_) => EditorProvider()),
      ],
      child: MaterialApp(
        title: 'Status Hub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}