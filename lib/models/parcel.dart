// 文件: lib/models/parcel.dart

// 这就像你定义的 C struct Parcel { ... }
class Parcel {
  final String pickupCode;  // 取件码 (如: 3-2056)
  final String location;    // 取件点 (如: 北区蜂巢柜)
  final String carrier;     // 快递公司 (如: 顺丰)
  final String status;      // 状态 (如: 待取)
  final String time;        // 入柜时间

  // 构造函数，强制要求创建时必须填这些数据
  Parcel({
    required this.pickupCode,
    required this.location,
    required this.carrier,
    required this.status,
    required this.time,
  });
}