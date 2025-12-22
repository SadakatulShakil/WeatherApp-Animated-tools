class ProfileModel {
  bool? status;
  String? message;
  Result? result;

  ProfileModel({this.status, this.message, this.result});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? id;
  String? fullname;
  String? email;
  String? mobile;
  String? address;
  String? lat;
  String? lon;
  String? status;
  String? roll;
  String? createdAt;
  String? updatedAt;

  Result(
      {this.id,
        this.fullname,
        this.email,
        this.mobile,
        this.address,
        this.lat,
        this.lon,
        this.status,
        this.roll,
        this.createdAt,
        this.updatedAt});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    email = json['email'];
    mobile = json['mobile'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    status = json['status'];
    roll = json['roll'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['status'] = this.status;
    data['roll'] = this.roll;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}