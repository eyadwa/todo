class TodoItem {
  String todo;
  String imageUrl;
  DateTime createdAt;
  bool isDone;

  TodoItem(this.todo, this.createdAt, {this.isDone = false, this.imageUrl = ""});

  Map<String, String> toJson() {
    Map<String, String> result = <String, String>{
      TODO: todo,
      CREATED_AT: createdAt.toIso8601String(),
      IS_DONE: isDone.toString(),
      IMAGE_URL: imageUrl
    };
    return result;
  }

  static TodoItem? fromJson(Map<String, String> todoNode) {
    String? todo = todoNode[TODO];
    if (todo == null) {
      return null;
    }

    String? dateTime = todoNode[CREATED_AT];
    if (dateTime == null) {
      return null;
    }
    DateTime createdAt = DateTime.parse(dateTime);

    return TodoItem(todo, createdAt);
  }

  static const CREATED_AT = "createdAt";
  static const IMAGE_URL = "imageUrl";
  static const IS_DONE = "isDone";
  static const TODO = "todo";
}
