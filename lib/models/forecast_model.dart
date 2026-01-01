class WeatherForecastModel {
  bool? status;
  String? message;
  ForecastResult? result;

  WeatherForecastModel({this.status, this.message, this.result});

  WeatherForecastModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? ForecastResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class ForecastResult {
  Location? location;
  ForecastEntry? current;
  List<ForecastEntry>? daily;
  List<ForecastEntry>? steps;
  ChartData? dailyChart;
  ChartData? stepsChart;

  ForecastResult({
    this.location,
    this.current,
    this.daily,
    this.steps,
    this.dailyChart,
    this.stepsChart,
  });

  ForecastResult.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    current = json['current'] != null
        ? ForecastEntry.fromJson(json['current'])
        : null;
    if (json['daily'] != null) {
      daily = <ForecastEntry>[];
      json['daily'].forEach((v) {
        daily!.add(ForecastEntry.fromJson(v));
      });
    }
    if (json['steps'] != null) {
      steps = <ForecastEntry>[];
      json['steps'].forEach((v) {
        steps!.add(ForecastEntry.fromJson(v));
      });
    }
    dailyChart = json['daily_chart'] != null
        ? ChartData.fromJson(json['daily_chart'])
        : null;
    stepsChart = json['steps_chart'] != null
        ? ChartData.fromJson(json['steps_chart'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (current != null) {
      data['current'] = current!.toJson();
    }
    if (daily != null) {
      data['daily'] = daily!.map((v) => v.toJson()).toList();
    }
    if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
    if (dailyChart != null) {
      data['daily_chart'] = dailyChart!.toJson();
    }
    if (stepsChart != null) {
      data['steps_chart'] = stepsChart!.toJson();
    }
    return data;
  }
}

class Location {
  String? id;
  String? division;
  String? district;
  String? upazila;
  String? divisionBn;
  String? districtBn;
  String? upazilaBn;
  String? forecastDate;
  String? updatedAt;
  String? locationName;

  Location({
    this.id,
    this.division,
    this.district,
    this.upazila,
    this.divisionBn,
    this.districtBn,
    this.upazilaBn,
    this.forecastDate,
    this.updatedAt,
    this.locationName,
  });

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    division = json['division'];
    district = json['district'];
    upazila = json['upazila'];
    divisionBn = json['division_bn'];
    districtBn = json['district_bn'];
    upazilaBn = json['upazila_bn'];
    forecastDate = json['forecast_date'];
    updatedAt = json['updated_at'];
    locationName = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['division'] = division;
    data['district'] = district;
    data['upazila'] = upazila;
    data['division_bn'] = divisionBn;
    data['district_bn'] = districtBn;
    data['upazila_bn'] = upazilaBn;
    data['forecast_date'] = forecastDate;
    data['updated_at'] = updatedAt;
    data['location'] = locationName;
    return data;
  }
}

class ForecastEntry {
  String? stepStart;
  String? stepEnd;
  String? start;
  String? end;
  String? date;
  String? weekday;
  String? rfUnit;
  String? tempUnit;
  String? rhUnit;
  String? windspdUnit;
  String? winddirUnit;
  String? cldcvrUnit;
  String? windgustUnit;
  String? icon;
  String? type;
  NumericRange? rf;
  NumericRange? temp;
  NumericRange? rh;
  NumericRange? windspd;
  NumericRange? winddir;
  NumericRange? cldcvr;
  NumericRange? windgust;

  // New Missing Fields from JSON
  String? pressure;
  String? feels;
  String? utci;
  String? uv;
  String? uvDesc;
  String? vis;
  String? aqi;
  String? aqiSeverity;
  String? aqLevel;
  String? primaryPollutant;
  String? sunrise;
  String? sunset;
  String? moonrise;
  String? moonset;
  String? moonPhase;

  ForecastEntry({
    this.stepStart,
    this.stepEnd,
    this.start,
    this.end,
    this.date,
    this.weekday,
    this.rfUnit,
    this.tempUnit,
    this.rhUnit,
    this.windspdUnit,
    this.winddirUnit,
    this.cldcvrUnit,
    this.windgustUnit,
    this.icon,
    this.type,
    this.rf,
    this.temp,
    this.rh,
    this.windspd,
    this.winddir,
    this.cldcvr,
    this.windgust,
    // Initialize new fields
    this.pressure,
    this.feels,
    this.utci,
    this.uv,
    this.uvDesc,
    this.vis,
    this.aqi,
    this.aqiSeverity,
    this.aqLevel,
    this.primaryPollutant,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
  });

  ForecastEntry.fromJson(Map<String, dynamic> json) {
    stepStart = json['step_start'];
    stepEnd = json['step_end'];
    start = json['start'];
    end = json['end'];
    date = json['date'];
    weekday = json['weekday'];
    rfUnit = json['rf_unit'];
    tempUnit = json['temp_unit'];
    rhUnit = json['rh_unit'];
    windspdUnit = json['windspd_unit'];
    winddirUnit = json['winddir_unit'];
    cldcvrUnit = json['cldcvr_unit'];
    windgustUnit = json['windgust_unit'];
    icon = json['icon'];
    type = json['type'];
    rf = json['rf'] != null ? NumericRange.fromJson(json['rf']) : null;
    temp = json['temp'] != null ? NumericRange.fromJson(json['temp']) : null;
    rh = json['rh'] != null ? NumericRange.fromJson(json['rh']) : null;
    windspd = json['windspd'] != null ? NumericRange.fromJson(json['windspd']) : null;
    winddir = json['winddir'] != null ? NumericRange.fromJson(json['winddir']) : null;
    cldcvr = json['cldcvr'] != null ? NumericRange.fromJson(json['cldcvr']) : null;
    windgust = json['windgust'] != null ? NumericRange.fromJson(json['windgust']) : null;

    // Parsing new fields
    pressure = json['pressure']?.toString();
    feels = json['feels']?.toString();
    utci = json['utci']?.toString();
    uv = json['uv']?.toString();
    uvDesc = json['uvDesc'];
    vis = json['vis']?.toString();
    aqi = json['aqi']?.toString();
    aqiSeverity = json['aqiSeverity'];
    aqLevel = json['aqLevel']?.toString();
    primaryPollutant = json['primaryPollutant'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    moonrise = json['moonrise'];
    moonset = json['moonset'];
    moonPhase = json['moonPhase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['step_start'] = stepStart;
    data['step_end'] = stepEnd;
    data['start'] = start;
    data['end'] = end;
    data['date'] = date;
    data['weekday'] = weekday;
    data['rf_unit'] = rfUnit;
    data['temp_unit'] = tempUnit;
    data['rh_unit'] = rhUnit;
    data['windspd_unit'] = windspdUnit;
    data['winddir_unit'] = winddirUnit;
    data['cldcvr_unit'] = cldcvrUnit;
    data['windgust_unit'] = windgustUnit;
    data['icon'] = icon;
    data['type'] = type;
    if (rf != null) data['rf'] = rf!.toJson();
    if (temp != null) data['temp'] = temp!.toJson();
    if (rh != null) data['rh'] = rh!.toJson();
    if (windspd != null) data['windspd'] = windspd!.toJson();
    if (winddir != null) data['winddir'] = winddir!.toJson();
    if (cldcvr != null) data['cldcvr'] = cldcvr!.toJson();
    if (windgust != null) data['windgust'] = windgust!.toJson();

    // Serializing new fields
    data['pressure'] = pressure;
    data['feels'] = feels;
    data['utci'] = utci;
    data['uv'] = uv;
    data['uvDesc'] = uvDesc;
    data['vis'] = vis;
    data['aqi'] = aqi;
    data['aqiSeverity'] = aqiSeverity;
    data['aqLevel'] = aqLevel;
    data['primaryPollutant'] = primaryPollutant;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['moonrise'] = moonrise;
    data['moonset'] = moonset;
    data['moonPhase'] = moonPhase;
    return data;
  }
}

class NumericRange {
  String? valMin;
  String? valAvg;
  String? valMax;

  NumericRange({this.valMin, this.valAvg, this.valMax});

  // Parses string numbers like "15.6" into actual doubles
  NumericRange.fromJson(Map<String, dynamic> json) {
    valMin = json['val_min']?.toString();
    valAvg = json['val_avg']?.toString();
    valMax = json['val_max']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['val_min'] = valMin?.toString();
    data['val_avg'] = valAvg?.toString();
    data['val_max'] = valMax?.toString();
    return data;
  }
}

// Handles daily_chart and steps_chart
class ChartData {
  List<double>? rfValMin;
  List<double>? rfValAvg;
  List<double>? rfValMax;
  List<double>? tempValMin;
  List<double>? tempValAvg;
  List<double>? tempValMax;
  List<double>? windValMin;
  List<double>? windValAvg;
  List<double>? windValMax;
  List<double>? rhValMin;
  List<double>? rhValAvg;
  List<double>? rhValMax;

  ChartData({
    this.rfValMin,
    this.rfValAvg,
    this.rfValMax,
    this.tempValMin,
    this.tempValAvg,
    this.tempValMax,
    this.windValMin,
    this.windValAvg,
    this.windValMax,
    this.rhValMin,
    this.rhValAvg,
    this.rhValMax,
  });

  ChartData.fromJson(Map<String, dynamic> json) {
    rfValMin = _parseList(json['rf_val_min']);
    rfValAvg = _parseList(json['rf_val_avg']);
    rfValMax = _parseList(json['rf_val_max']);
    tempValMin = _parseList(json['temp_val_min']);
    tempValAvg = _parseList(json['temp_val_avg']);
    tempValMax = _parseList(json['temp_val_max']);
    windValMin = _parseList(json['wind_val_min']);
    windValAvg = _parseList(json['wind_val_avg']);
    windValMax = _parseList(json['wind_val_max']);
    rhValMin = _parseList(json['rh_val_min']);
    rhValAvg = _parseList(json['rh_val_avg']);
    rhValMax = _parseList(json['rh_val_max']);
  }

  // Helper to convert List<dynamic/String> to List<double>
  List<double>? _parseList(dynamic list) {
    if (list == null) return null;
    if (list is List) {
      return list.map((e) => double.tryParse(e.toString()) ?? 0.0).toList();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rf_val_min'] = rfValMin?.map((e) => e.toString()).toList();
    data['rf_val_avg'] = rfValAvg?.map((e) => e.toString()).toList();
    data['rf_val_max'] = rfValMax?.map((e) => e.toString()).toList();
    data['temp_val_min'] = tempValMin?.map((e) => e.toString()).toList();
    data['temp_val_avg'] = tempValAvg?.map((e) => e.toString()).toList();
    data['temp_val_max'] = tempValMax?.map((e) => e.toString()).toList();
    data['wind_val_min'] = windValMin?.map((e) => e.toString()).toList();
    data['wind_val_avg'] = windValAvg?.map((e) => e.toString()).toList();
    data['wind_val_max'] = windValMax?.map((e) => e.toString()).toList();
    data['rh_val_min'] = rhValMin?.map((e) => e.toString()).toList();
    data['rh_val_avg'] = rhValAvg?.map((e) => e.toString()).toList();
    data['rh_val_max'] = rhValMax?.map((e) => e.toString()).toList();
    return data;
  }
}