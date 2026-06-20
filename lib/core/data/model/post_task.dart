/// Request model for POST /tasks
class PostTask {
  final String title;
  final String description;

  const PostTask({
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'title':       title,
    'description': description,
    'status':      'pending',
  };
}