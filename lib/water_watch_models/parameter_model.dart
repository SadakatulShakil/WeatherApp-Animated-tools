class ParameterModel {
  final String id;
  final String title;

  ParameterModel({required this.id, required this.title});

  factory ParameterModel.fromJson(Map<String, dynamic> json) {
    return ParameterModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
