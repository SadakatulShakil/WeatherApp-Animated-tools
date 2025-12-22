import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

import 'dao/record_dao.dart';

import 'entity/record_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [RecordEntity])
abstract class AppDatabase extends FloorDatabase {
  RecordDao get recordDao;
}