import 'package:flutter/material.dart';
import '../models/parcel.dart'; // 你的 Parcel 模型
import 'dart:ui'; // 用于 ImageFilter

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 数据列表
  // --- 1. 定义当前主题的索引（默认第0套） ---
  int _currentThemeIndex = 0;

  // --- 2. 定义主题衣柜 (支持渐变色和网络图片) ---
  final List<BoxDecoration> _themes = [
    // [0] 默认：深蓝极光
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
      ),
    ),
    // [1] 唯美：樱花粉
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFff9a9e), Color(0xFFfecfef)],
      ),
    ),
    // [2] 高级：黑金流沙
    const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF434343), Color(0xFF000000)],
      ),
    ),
    // [3] 图片：赛博朋克 (使用网络图片)
    const BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(
          'https://images.unsplash.com/photo-1555680202-c86f0e12f086?q=80&w=1000&auto=format&fit=crop',
        ),
        fit: BoxFit.cover, // 撑满屏幕
      ),
    ),
  ];
  List<Parcel> parcels = [
    Parcel(
      pickupCode: '99-11-11',
      location: '北门丰巢',
      carrier: '顺丰',
      status: '待取',
      time: '12:00',
    ),
    Parcel(
      pickupCode: '3-2056',
      location: '南苑食堂',
      carrier: '京东',
      status: '待取',
      time: '14:30',
    ),
    Parcel(
      pickupCode: '1-8848',
      location: '西区驿站',
      carrier: '圆通',
      status: '待取',
      time: '18:00',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _sortParcels(); // 一启动就排序
  }

  // 排序函数
  void _sortParcels() {
    parcels.sort((a, b) {
      int compareResult = a.location.compareTo(b.location);
      if (compareResult == 0) {
        return a.time.compareTo(b.time);
      }
      return compareResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('待取包裹', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens, color: Colors.white),
            onPressed: _showThemePicker, // 点击调用底部弹窗
          ),
        ],
      ),
      // 使用 Stack 堆叠背景和内容
      body: Stack(
        children: [
          // --- 层级 0: 唯美的渐变背景 ---
          // --- 层级 0: 动态背景 ---
          Container(
            // 使用当前选中的主题，而不是写死的代码
            decoration: _themes[_currentThemeIndex],
            // 加一个过渡动画，让切换更丝滑（可选）
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0), // 占位，保持结构
              child: Container(color: Colors.transparent),
            ),
          ),

          // --- 层级 1: 内容区域 ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: parcels.length,
                      itemBuilder: (context, index) {
                        final parcel = parcels[index];
                        return Dismissible(
                          key: Key(parcel.pickupCode),
                          background: Container(
                            color: Colors.red.withOpacity(0.8), // 稍微透明一点的红色更好看
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          onDismissed: (direction) {
                            final deletedParcel = parcels[index];
                            final deletedIndex = index;

                            setState(() {
                              parcels.removeAt(index);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('已取出 ${parcel.pickupCode}'),
                                duration: const Duration(seconds: 3),
                                action: SnackBarAction(
                                  label: '撤销',
                                  onPressed: () {
                                    setState(() {
                                      parcels.insert(
                                        deletedIndex,
                                        deletedParcel,
                                      );
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          // 使用 GlassContainer 包裹卡片
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildPickupCard(parcel),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  _buildIdentityButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 显示底部换肤菜单 ---
  void _showThemePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // 背景透明，为了显示玻璃感
      builder: (context) {
        return GlassContainer(
          // 复用你的玻璃组件
          opacity: 0.9,
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "选择背景风格",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                // 横向滚动的预览列表
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // 横着排
                    itemCount: _themes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // 选中后更新界面
                          setState(() {
                            _currentThemeIndex = index;
                          });
                          Navigator.pop(context); // 关闭弹窗
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: _currentThemeIndex == index
                                ? Border.all(
                                    color: Colors.blueAccent,
                                    width: 3,
                                  ) // 选中的加个蓝框
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          // 这是一个小小的预览图，显示该主题的样式
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Container(decoration: _themes[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 玻璃卡片构建函数 ---
  Widget _buildPickupCard(Parcel parcel) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // 左侧：取件码容器
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                parcel.pickupCode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 中间信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parcel.location,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${parcel.carrier} · ${parcel.time}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  // --- 身份码按钮构建函数 ---
  Widget _buildIdentityButton() {
    return GlassContainer(
      opacity: 0.3,
      child: InkWell(
        onTap: () {
          print("点击了");
        },
        child: Container(
          height: 60,
          alignment: Alignment.center,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "打开身份码",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} // <--- 这个大括号是 _HomeScreenState 类的结束，千万别删！

// --- 下面是通用的玻璃容器类（在类外面定义） ---
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double opacity;

  const GlassContainer({super.key, required this.child, this.opacity = 0.15});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
