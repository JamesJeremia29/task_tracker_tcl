/// Enum representation of task status
/// Keeps status values consistent across the app
enum StatusModel {
  pending('pending'),
  done('done');

  final String value;
  const StatusModel(this.value);

  static StatusModel fromString(String value) {
    return StatusModel.values.firstWhere(
      (s) => s.value == value,
      orElse: () => StatusModel.pending,
    );
  }

  bool get isDone    => this == StatusModel.done;
  bool get isPending => this == StatusModel.pending;

  StatusModel get toggled =>
      isDone ? StatusModel.pending : StatusModel.done;
}