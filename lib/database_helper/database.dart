import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import 'dao/location_dao.dart';
import 'dao/parameter_dao.dart';
import 'dao/record_dao.dart';
import 'entity/local_location_entity.dart';
import 'entity/local_parameter_entity.dart';
import 'entity/record_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [LocationEntity, ParameterEntity, RecordEntity])
abstract class AppDatabase extends FloorDatabase {
  LocationDao get locationDao;
  ParameterDao get parameterDao;
  RecordDao get recordDao;
}