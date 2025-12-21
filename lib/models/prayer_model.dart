class PrayerModel {
  bool? status;
  String? message;
  Result? result;

  PrayerModel({this.status, this.message, this.result});

  PrayerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
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

class Result {
  String? date;
  String? islamicDate;
  String? banglaDate;
  int? day;
  String? sehri;
  String? fajr;
  String? sunrise;
  String? noon;
  String? juhr;
  String? asr;
  String? sunset;
  String? iftar;
  String? magrib;
  String? isha;
  String? tahajjut;
  String? ishrak;
  String? wish;

  Result(
      {this.date,
        this.islamicDate,
        this.banglaDate,
        this.day,
        this.sehri,
        this.fajr,
        this.sunrise,
        this.noon,
        this.juhr,
        this.asr,
        this.sunset,
        this.iftar,
        this.magrib,
        this.isha,
        this.tahajjut,
        this.ishrak,
        this.wish});

  Result.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    islamicDate = json['IslamicDate'];
    banglaDate = json['BanglaDate'];
    day = json['Day'];
    sehri = json['Sehri'];
    fajr = json['Fajr'];
    sunrise = json['Sunrise'];
    noon = json['Noon'];
    juhr = json['Juhr'];
    asr = json['Asr'];
    sunset = json['Sunset'];
    iftar = json['Iftar'];
    magrib = json['Magrib'];
    isha = json['Isha'];
    tahajjut = json['Tahajjut'];
    ishrak = json['Ishrak'];
    wish = json['wish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Date'] = date;
    data['IslamicDate'] = islamicDate;
    data['BanglaDate'] = banglaDate;
    data['Day'] = day;
    data['Sehri'] = sehri;
    data['Fajr'] = fajr;
    data['Sunrise'] = sunrise;
    data['Noon'] = noon;
    data['Juhr'] = juhr;
    data['Asr'] = asr;
    data['Sunset'] = sunset;
    data['Iftar'] = iftar;
    data['Magrib'] = magrib;
    data['Isha'] = isha;
    data['Tahajjut'] = tahajjut;
    data['Ishrak'] = ishrak;
    data['wish'] = wish;
    return data;
  }
}