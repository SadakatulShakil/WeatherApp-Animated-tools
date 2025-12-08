import 'package:floor/floor.dart';

import '../entity/local_parameter_entity.dart';


@dao
abstract class ParameterDao {
  @Query('SELECT * FROM ParameterEntity')
  Future<List<ParameterEntity>> findAllParameters();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertParameters(List<ParameterEntity> parameters);
}