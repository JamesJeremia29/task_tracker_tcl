/// Request model for PATCH /tasks/:id
class UpdateTask {
  final String status;

  const UpdateTask({required this.status});

  Map<String, dynamic> toJson() => {
    'status': status,
  };
}