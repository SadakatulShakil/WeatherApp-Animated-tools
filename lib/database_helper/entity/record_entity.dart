import 'package:floor/floor.dart';

@Entity(tableName: 'record_entity')
class RecordEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String date; // format: YYYY-MM-DD
  final String time; // e.g., 03:55 PM

  final String locationId;
  final String locationName;

  final String parameterId;
  final String parameterName;

  final String measurement;

  final String? image1Path;
  final String? image2Path;
  final String? image3Path;

  final bool isSynced;

  RecordEntity({
    this.id,
    required this.date,
    required this.time,
    required this.locationId,
    required this.locationName,
    required this.parameterId,
    required this.parameterName,
    required this.measurement,
    this.image1Path,
    this.image2Path,
    this.image3Path,
    this.isSynced = false,
  });
}
