import 'package:flutter/material.dart';
import '../models/parcel.dart'; // <--- 1. 引入刚才定义的结构体

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- 2. 模拟从数据库里查出来的一条数据 ---
    // 在真实 App 中，这里会是从 API 获取的 JSON
    final Parcel myParcel = Parcel(
      pickupCode: '7-9981',     // 改个号码试试，看 App 变没变
      location: '南邮东门邮局',
      carrier: '邮政快递',
      status: '待取件',
      time: '18:20 入库',
    );
    // -------------------------------------

    return Scaffold(
      appBar: AppBar(
        title: const Text('待取包裹'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- 3. 把数据传给卡片函数 ---
            _buildPickupCard(myParcel), 
            const SizedBox(height: 20),
            _buildIdentityButton(),
          ],
        ),
      ),
    );
  }

  // --- 4. 修改函数签名，让它接收 Parcel 对象 ---
  Widget _buildPickupCard(Parcel parcel) { 
    return Card(
      elevation: 4,
      color: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '最近待取',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                parcel.pickupCode, // <--- 5. 这里换成变量！
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.orangeAccent, size: 20),
                const SizedBox(width: 5),
                Text(
                  parcel.location, // <--- 6. 变量
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(color: Colors.white24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(parcel.carrier, style: const TextStyle(color: Colors.white70)), // <--- 变量
                Text(parcel.time, style: const TextStyle(color: Colors.white70)),    // <--- 变量
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityButton() {
    // ... (这部分代码不用动)
    return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () { print("点击了打开身份码"); },
          icon: const Icon(Icons.qr_code, size: 28),
          label: const Text('打开身份码', style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
        ));
  }
}