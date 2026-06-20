class PromptConst {
  PromptConst._();

  //App
  static const String appName = 'Task Tracker';

  //Navigation / Page titles
  static const String taskList   = 'My Tasks';
  static const String addTask    = 'Add Task';
  static const String taskDetail = 'Task Detail';

  //Form labels
  static const String titleLabel       = 'Title';
  static const String descriptionLabel = 'Description';
  static const String titleHint        = 'Enter task title';
  static const String descriptionHint  = 'Enter task description';

  //Form validation
  static const String titleRequired       = 'Title is required';
  static const String titleTooShort       = 'Title must be at least 3 characters';
  static const String titleTooLong        = 'Title must be under 100 characters';
  static const String descriptionRequired = 'Description is required';

  //Buttons / Actions
  static const String save        = 'Save Task';
  static const String markDone    = 'Mark as Done';
  static const String markPending = 'Mark as Pending';
  static const String retry       = 'Try Again';

  //Status labels
  static const String done    = 'Done';
  static const String pending = 'Pending';

  //Empty state
  static const String emptyTitle    = 'No tasks yet';
  static const String emptySubtitle = 'Tap + to add your first task';

  //Success messages
  static const String taskAdded   = 'Task added successfully';
  static const String taskUpdated = 'Task status updated';
}