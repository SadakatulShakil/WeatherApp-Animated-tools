class DashboardModel {
  bool? status;
  String? message;
  List<DashboardModule>? result;

  DashboardModel({this.status, this.message, this.result});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <DashboardModule>[];
      json['result'].forEach((v) {
        result!.add(DashboardModule.fromJson(v));
      });
    }
  }
}

class DashboardModule {
  String? id;
  String? name;
  String? url;
  String? icon;

  DashboardModule({this.id, this.name, this.url, this.icon});

  DashboardModule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    icon = json['icon'];
  }
}