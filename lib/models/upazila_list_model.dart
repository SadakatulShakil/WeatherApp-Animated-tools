class UpazilaListModel {
  String? status;
  List<Data>? data;

  UpazilaListModel({this.status, this.data});

  UpazilaListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? name;
  String? name_bn;
  String? pcode;
  dynamic lat;
  dynamic lng;
  String? district;
  String? district_bn;
  String? districtCode;
  String? division;
  String? divisionCode;

  Data(
      {
        this.name,
        this.name_bn,
        this.pcode,
        this.lat,
        this.lng,
        this.district,
        this.district_bn,
        this.districtCode,
        this.division,
        this.divisionCode});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    name_bn = json['name_bn'];
    pcode = json['pcode'];
    lat = json['lat'];
    lng = json['lng'];
    district = json['district'];
    district_bn = json['district_bn'];
    districtCode = json['district_code'];
    division = json['division'];
    divisionCode = json['division_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_bn'] = this.name_bn;
    data['pcode'] = this.pcode;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['district'] = this.district;
    data['district_bn'] = this.district_bn;
    data['district_code'] = this.districtCode;
    data['division'] = this.division;
    data['division_code'] = this.divisionCode;
    return data;
  }
}