import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime createdAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  //Computed properties
  bool get isDone    => status == 'done';
  bool get isPending => status == 'pending';

  //Deserialization
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id:          json['id'] as String,
      title:       json['title'] as String,
      description: json['description'] as String? ?? '',
      status:      json['status'] as String? ?? 'pending',
      createdAt:   DateTime.parse(json['created_at'] as String),
    );
  }

  //Serialization
  Map<String, dynamic> toJson() => {
    'id':          id,
    'title':       title,
    'description': description,
    'status':      status,
    'created_at':  createdAt.toIso8601String(),
  };

  // Used for POST (no id/created_at yet)
  Map<String, dynamic> toInsertJson() => {
    'title':       title,
    'description': description,
    'status':      'pending',
  };

  // Used for PATCH (only update status)
  Map<String, dynamic> toUpdateJson() => {
    'status': status,
  };

  // ─── CopyWith ──────────────────────────────────────────────
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id:          id          ?? this.id,
      title:       title       ?? this.title,
      description: description ?? this.description,
      status:      status      ?? this.status,
      createdAt:   createdAt   ?? this.createdAt,
    );
  }

  //Equatable
  @override
  List<Object?> get props => [id, title, description, status, createdAt];

  @override
  String toString() =>
      'TaskModel(id: $id, title: $title, status: $status)';
}