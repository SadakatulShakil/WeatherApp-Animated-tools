import 'package:floor/floor.dart';

import '../entity/local_location_entity.dart';

@dao
abstract class LocationDao {
  @Query('SELECT * FROM LocationEntity')
  Future<List<LocationEntity>> findAllLocations();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertLocations(List<LocationEntity> locations);
}