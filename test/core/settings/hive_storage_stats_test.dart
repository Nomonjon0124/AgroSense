import 'dart:io';

import 'package:agro_sense/core/settings/storage_stats_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  test(
    'StorageStatsService computes byte usage and available budget',
    () async {
      final tempDir = await Directory.systemTemp.createTemp('hive_stats_test');
      Hive.init(tempDir.path);

      final weather = await Hive.openBox('weather');
      final soilMoisture = await Hive.openBox('soilM');
      final soilProperties = await Hive.openBox('soilP');

      await weather.put('weather_1', '{"temp":22}');
      await soilMoisture.put('soil_1', '{"moisture":0.33}');
      await soilProperties.put('soil_props_1', '{"ph":6.7}');

      final service = StorageStatsService(
        weatherBox: weather,
        soilMoistureBox: soilMoisture,
        soilPropertiesBox: soilProperties,
      );

      final stats = await service.computeStats(budgetBytes: 1024 * 1024);

      expect(stats.entryCount, 3);
      expect(stats.usedBytes, greaterThan(0));
      expect(stats.availableBytes, lessThanOrEqualTo(1024 * 1024));
      expect(stats.usageFraction, inInclusiveRange(0.0, 1.0));

      await weather.close();
      await soilMoisture.close();
      await soilProperties.close();
      await tempDir.delete(recursive: true);
    },
  );
}
