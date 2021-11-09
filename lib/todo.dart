class Todo {
  Todo(this.title, this.created, this.completed);

  String title;
  String created;
  bool completed;

  void toggleCompletedStatus() {
    completed = !completed;
  }

  String encode() {
    return "$title***|***$created***|***$completed";
  }
}
