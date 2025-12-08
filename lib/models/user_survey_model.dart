class Question {
  final int id;
  final String question;
  final List<String> options;

  Question({
    required this.id,
    required this.question,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
    );
  }
}

List<Question> parseQuestions(List<dynamic> data) {
  return data.map((e) => Question.fromJson(e)).toList();
}
