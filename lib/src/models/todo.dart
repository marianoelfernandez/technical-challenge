import "package:equatable/equatable.dart";

class Todo extends Equatable {
  final String id;
  final String title;
  final bool isDone;
  final String userId;
  final DateTime createdAt;

  const Todo({
    required this.id,
    required this.title,
    required this.isDone,
    required this.userId,
    required this.createdAt,
  });

  factory Todo.create({
    required String title,
    required String userId,
  }) {
    return Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isDone: false,
      userId: userId,
      createdAt: DateTime.now(),
    );
  }

  Todo copyWith({
    String? id,
    String? title,
    bool? isDone,
    String? userId,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"] as String,
        title: json["title"] as String,
        isDone: json["isDone"] as bool,
        userId: json["userId"] as String,
        createdAt: DateTime.parse(json["createdAt"] as String),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "isDone": isDone,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, title, isDone, userId, createdAt];
}
