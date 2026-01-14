// 文件名: lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // 引入我们将要写的首页

void main() {
  runApp(const CampusPakApp());
}

class CampusPakApp extends StatelessWidget {
  const CampusPakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusPak',
      theme: ThemeData(
        // 这里定义 App 的主题色，我们用 ROG 风格的红色试试？
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // 启动后显示 HomeScreen
    );
  }
}