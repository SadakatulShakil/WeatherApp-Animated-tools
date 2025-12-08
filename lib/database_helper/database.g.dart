// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  LocationDao? _locationDaoInstance;

  ParameterDao? _parameterDaoInstance;

  RecordDao? _recordDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `LocationEntity` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `titleBn` TEXT NOT NULL, `subtitle` TEXT NOT NULL, `subtitleBn` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ParameterEntity` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `titleBn` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `record_entity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `time` TEXT NOT NULL, `locationId` TEXT NOT NULL, `locationName` TEXT NOT NULL, `parameterId` TEXT NOT NULL, `parameterName` TEXT NOT NULL, `measurement` TEXT NOT NULL, `image1Path` TEXT, `image2Path` TEXT, `image3Path` TEXT, `isSynced` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  LocationDao get locationDao {
    return _locationDaoInstance ??= _$LocationDao(database, changeListener);
  }

  @override
  ParameterDao get parameterDao {
    return _parameterDaoInstance ??= _$ParameterDao(database, changeListener);
  }

  @override
  RecordDao get recordDao {
    return _recordDaoInstance ??= _$RecordDao(database, changeListener);
  }
}

class _$LocationDao extends LocationDao {
  _$LocationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _locationEntityInsertionAdapter = InsertionAdapter(
            database,
            'LocationEntity',
            (LocationEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'titleBn': item.titleBn,
                  'subtitle': item.subtitle,
                  'subtitleBn': item.subtitleBn
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LocationEntity> _locationEntityInsertionAdapter;

  @override
  Future<List<LocationEntity>> findAllLocations() async {
    return _queryAdapter.queryList('SELECT * FROM LocationEntity',
        mapper: (Map<String, Object?> row) => LocationEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            titleBn: row['titleBn'] as String,
            subtitle: row['subtitle'] as String,
            subtitleBn: row['subtitleBn'] as String));
  }

  @override
  Future<void> insertLocations(List<LocationEntity> locations) async {
    await _locationEntityInsertionAdapter.insertList(
        locations, OnConflictStrategy.replace);
  }
}

class _$ParameterDao extends ParameterDao {
  _$ParameterDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _parameterEntityInsertionAdapter = InsertionAdapter(
            database,
            'ParameterEntity',
            (ParameterEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'titleBn': item.titleBn
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ParameterEntity> _parameterEntityInsertionAdapter;

  @override
  Future<List<ParameterEntity>> findAllParameters() async {
    return _queryAdapter.queryList('SELECT * FROM ParameterEntity',
        mapper: (Map<String, Object?> row) => ParameterEntity(
            id: row['id'] as String,
            title: row['title'] as String,
            titleBn: row['titleBn'] as String));
  }

  @override
  Future<void> insertParameters(List<ParameterEntity> parameters) async {
    await _parameterEntityInsertionAdapter.insertList(
        parameters, OnConflictStrategy.replace);
  }
}

class _$RecordDao extends RecordDao {
  _$RecordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _recordEntityInsertionAdapter = InsertionAdapter(
            database,
            'record_entity',
            (RecordEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'time': item.time,
                  'locationId': item.locationId,
                  'locationName': item.locationName,
                  'parameterId': item.parameterId,
                  'parameterName': item.parameterName,
                  'measurement': item.measurement,
                  'image1Path': item.image1Path,
                  'image2Path': item.image2Path,
                  'image3Path': item.image3Path,
                  'isSynced': item.isSynced ? 1 : 0
                }),
        _recordEntityDeletionAdapter = DeletionAdapter(
            database,
            'record_entity',
            ['id'],
            (RecordEntity item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'time': item.time,
                  'locationId': item.locationId,
                  'locationName': item.locationName,
                  'parameterId': item.parameterId,
                  'parameterName': item.parameterName,
                  'measurement': item.measurement,
                  'image1Path': item.image1Path,
                  'image2Path': item.image2Path,
                  'image3Path': item.image3Path,
                  'isSynced': item.isSynced ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RecordEntity> _recordEntityInsertionAdapter;

  final DeletionAdapter<RecordEntity> _recordEntityDeletionAdapter;

  @override
  Future<List<RecordEntity>> getRecordsByDate(String date) async {
    return _queryAdapter.queryList(
        'SELECT * FROM record_entity WHERE date = ?1',
        mapper: (Map<String, Object?> row) => RecordEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            time: row['time'] as String,
            locationId: row['locationId'] as String,
            locationName: row['locationName'] as String,
            parameterId: row['parameterId'] as String,
            parameterName: row['parameterName'] as String,
            measurement: row['measurement'] as String,
            image1Path: row['image1Path'] as String?,
            image2Path: row['image2Path'] as String?,
            image3Path: row['image3Path'] as String?,
            isSynced: (row['isSynced'] as int) != 0),
        arguments: [date]);
  }

  @override
  Future<List<RecordEntity>> getRecordsByYearAndParam(
    String year,
    String paramId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM record_entity    WHERE strftime(\'%Y\', date) = ?1      AND parameterId = ?2   ORDER BY date DESC, time ASC',
        mapper: (Map<String, Object?> row) => RecordEntity(id: row['id'] as int?, date: row['date'] as String, time: row['time'] as String, locationId: row['locationId'] as String, locationName: row['locationName'] as String, parameterId: row['parameterId'] as String, parameterName: row['parameterName'] as String, measurement: row['measurement'] as String, image1Path: row['image1Path'] as String?, image2Path: row['image2Path'] as String?, image3Path: row['image3Path'] as String?, isSynced: (row['isSynced'] as int) != 0),
        arguments: [year, paramId]);
  }

  @override
  Future<List<RecordEntity>> getAllRecords() async {
    return _queryAdapter.queryList('SELECT * FROM record_entity',
        mapper: (Map<String, Object?> row) => RecordEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            time: row['time'] as String,
            locationId: row['locationId'] as String,
            locationName: row['locationName'] as String,
            parameterId: row['parameterId'] as String,
            parameterName: row['parameterName'] as String,
            measurement: row['measurement'] as String,
            image1Path: row['image1Path'] as String?,
            image2Path: row['image2Path'] as String?,
            image3Path: row['image3Path'] as String?,
            isSynced: (row['isSynced'] as int) != 0));
  }

  @override
  Future<List<RecordEntity>> getUnsyncedRecords() async {
    return _queryAdapter.queryList(
        'SELECT * FROM record_entity WHERE isSynced = 0',
        mapper: (Map<String, Object?> row) => RecordEntity(
            id: row['id'] as int?,
            date: row['date'] as String,
            time: row['time'] as String,
            locationId: row['locationId'] as String,
            locationName: row['locationName'] as String,
            parameterId: row['parameterId'] as String,
            parameterName: row['parameterName'] as String,
            measurement: row['measurement'] as String,
            image1Path: row['image1Path'] as String?,
            image2Path: row['image2Path'] as String?,
            image3Path: row['image3Path'] as String?,
            isSynced: (row['isSynced'] as int) != 0));
  }

  @override
  Future<void> markAsSynced(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE record_entity SET isSynced = 1 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<List<RecordEntity>> getRecordsByStationAndParam(
    String stationId,
    String paramId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM record_entity WHERE locationId = ?1 AND parameterId = ?2 ORDER BY date DESC, time ASC',
        mapper: (Map<String, Object?> row) => RecordEntity(id: row['id'] as int?, date: row['date'] as String, time: row['time'] as String, locationId: row['locationId'] as String, locationName: row['locationName'] as String, parameterId: row['parameterId'] as String, parameterName: row['parameterName'] as String, measurement: row['measurement'] as String, image1Path: row['image1Path'] as String?, image2Path: row['image2Path'] as String?, image3Path: row['image3Path'] as String?, isSynced: (row['isSynced'] as int) != 0),
        arguments: [stationId, paramId]);
  }

  @override
  Future<void> insertRecord(RecordEntity record) async {
    await _recordEntityInsertionAdapter.insert(
        record, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteRecord(RecordEntity record) async {
    await _recordEntityDeletionAdapter.delete(record);
  }
}
