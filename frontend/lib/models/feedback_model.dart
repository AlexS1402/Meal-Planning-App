class FeedbackModel {
  final String id;
  final String userId;  // To link feedback to a specific user
  final String content;  // Actual feedback content
  final DateTime date;  // When the feedback was provided

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.date,
  });

  // Factory constructor to create a FeedbackModel from a map
  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'],
      userId: map['userId'],
      content: map['content'],
      date: DateTime.parse(map['date']),
    );
  }

  // Method to convert FeedbackModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'date': date.toIso8601String(),
    };
  }
}
