import 'dart:async';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper/database.dart';
import 'entity/local_location_entity.dart';
import 'entity/local_parameter_entity.dart';
import 'entity/record_entity.dart';

class DBService extends GetxService {
  late AppDatabase _database;

  Future<DBService> init() async {
    try {
      print('DEBUG: Starting database initialization...');

      // Add timeout to prevent hanging
      _database = await $FloorAppDatabase
          .databaseBuilder('offline.db')
          .build()
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Database initialization timed out');
      });

      print('DEBUG: Database initialized successfully');
      return this;
    } catch (e) {
      print('🔥 DATABASE INIT FAILED: $e');
      // Try to delete corrupt database and recreate
      try {
        await deleteDatabase('offlinewwe.db');
        print('DEBUG: Deleted corrupt database, retrying...');
        _database = await $FloorAppDatabase
            .databaseBuilder('offlinewwe.db')
            .build();
        print('DEBUG: Database recreated successfully');
        return this;
      } catch (e2) {
        print('🔥 DATABASE RECREATION FAILED: $e2');
        rethrow;
      }
    }
  }

  Future<void> saveLocations(List<LocationEntity> locations) async {
    await _database.locationDao.insertLocations(locations);
  }

  Future<List<LocationEntity>> loadLocations() async {
    return await _database.locationDao.findAllLocations();
  }

  Future<void> saveParameters(List<ParameterEntity> params) async {
    await _database.parameterDao.insertParameters(params);
  }

  Future<List<ParameterEntity>> loadParameters() async {
    return await _database.parameterDao.findAllParameters();
  }

  Future<void> saveRecord(RecordEntity record) async {
    await _database.recordDao.insertRecord(record);
  }

  Future<List<RecordEntity>> loadRecords() async {
    return await _database.recordDao.getAllRecords();
  }

  Future<void> deleteRecord(RecordEntity record) async {
    await _database.recordDao.deleteRecord(record);
  }

  Future<List<RecordEntity>> loadRecordsByDateAndParam(String year, String paramId) async {
    print('check loadRecordsByDateAndParam: $year, $paramId');
    return await _database.recordDao.getRecordsByYearAndParam(year, paramId);
  }

  Future<List<RecordEntity>> loadRecordsByStationAndParameter(String stationId, String parameterId) async {
    return await _database.recordDao.getRecordsByStationAndParam(stationId, parameterId);
  }
}