// 文件名: lib/screens/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold 是页面的脚手架，提供顶部栏、背景色等
    return Scaffold(
      appBar: AppBar(
        title: const Text('待取包裹'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 给四周留点白
        child: Column(
          children: [
            // --- 核心组件：取件码卡片 ---
            _buildPickupCard(),
            
            const SizedBox(height: 20), // 增加一点垂直间距
            
            // --- 核心组件：身份码按钮 ---
            _buildIdentityButton(),
          ],
        ),
      ),
    );
  }

  // 把卡片 UI 封装成一个函数，类似 C 语言把逻辑拆分成子函数
  Widget _buildPickupCard() {
    return Card(
      elevation: 4, // 阴影深度，看起来是浮起来的
      color: Colors.blueGrey[900], // 深色背景，护眼
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
          children: [
            const Text(
              '最近待取', 
              style: TextStyle(color: Colors.white70, fontSize: 14)
            ),
            const SizedBox(height: 10),
            const Center( // 取件码居中显示
              child: Text(
                '3-2056', 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 48, // 超大字体
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0, // 字间距，防止看错
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.orangeAccent, size: 20),
                SizedBox(width: 5),
                Text(
                  '北区宿舍楼下蜂巢柜', 
                  style: TextStyle(color: Colors.white, fontSize: 18)
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(color: Colors.white24), // 一条细分割线
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('顺丰速运', style: TextStyle(color: Colors.white70)),
                Text('14:30 入柜', style: TextStyle(color: Colors.white70)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityButton() {
    return SizedBox(
      width: double.infinity, // 按钮占满宽度
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          print("点击了打开身份码"); // 这里的输出会在 VS Code 的 DEBUG CONSOLE 看到
        },
        icon: const Icon(Icons.qr_code, size: 28),
        label: const Text('打开身份码', style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}