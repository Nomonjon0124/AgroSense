import 'dart:convert';

import 'package:hive_ce/hive.dart';

class StorageStats {
  final int usedBytes;
  final int budgetBytes;
  final int entryCount;

  const StorageStats({
    required this.usedBytes,
    required this.budgetBytes,
    required this.entryCount,
  });

  int get availableBytes {
    final available = budgetBytes - usedBytes;
    return available > 0 ? available : 0;
  }

  double get usageFraction {
    if (budgetBytes == 0) return 0;
    final ratio = usedBytes / budgetBytes;
    if (ratio < 0) return 0;
    if (ratio > 1) return 1;
    return ratio;
  }
}

class StorageStatsService {
  static const int defaultBudgetBytes = 2 * 1024 * 1024 * 1024; // 2GB

  final Box<dynamic> weatherBox;
  final Box<dynamic> soilMoistureBox;
  final Box<dynamic> soilPropertiesBox;

  const StorageStatsService({
    required this.weatherBox,
    required this.soilMoistureBox,
    required this.soilPropertiesBox,
  });

  Future<StorageStats> computeStats({
    int budgetBytes = defaultBudgetBytes,
  }) async {
    final used =
        _estimateBoxBytes(weatherBox) +
        _estimateBoxBytes(soilMoistureBox) +
        _estimateBoxBytes(soilPropertiesBox);

    final entries =
        weatherBox.length + soilMoistureBox.length + soilPropertiesBox.length;

    return StorageStats(
      usedBytes: used,
      budgetBytes: budgetBytes,
      entryCount: entries,
    );
  }

  Future<void> clearOfflineCaches() async {
    await weatherBox.clear();
    await soilMoistureBox.clear();
    await soilPropertiesBox.clear();
  }

  int _estimateBoxBytes(Box<dynamic> box) {
    var total = 0;
    for (final key in box.keys) {
      total += utf8.encode(key.toString()).length;
      total += utf8.encode((box.get(key)).toString()).length;
    }
    return total;
  }
}
