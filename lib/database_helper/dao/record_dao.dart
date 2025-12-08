import 'package:floor/floor.dart';

import '../entity/record_entity.dart';

@dao
abstract class RecordDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRecord(RecordEntity record);

  @Query('SELECT * FROM record_entity WHERE date = :date')
  Future<List<RecordEntity>> getRecordsByDate(String date);

  @Query('''SELECT * FROM record_entity 
  WHERE strftime('%Y', date) = :year 
    AND parameterId = :paramId
  ORDER BY date DESC, time ASC
''')
  Future<List<RecordEntity>> getRecordsByYearAndParam(String year, String paramId);


  @Query('SELECT * FROM record_entity')
  Future<List<RecordEntity>> getAllRecords();

  @Query('SELECT * FROM record_entity WHERE isSynced = 0')
  Future<List<RecordEntity>> getUnsyncedRecords();

  @Query('UPDATE record_entity SET isSynced = 1 WHERE id = :id')
  Future<void> markAsSynced(int id);

  @delete
  Future<void> deleteRecord(RecordEntity record);

  @Query('SELECT * FROM record_entity WHERE locationId = :stationId AND parameterId = :paramId ORDER BY date DESC, time ASC')
  Future<List<RecordEntity>> getRecordsByStationAndParam(String stationId, String paramId);

}
