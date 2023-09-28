class TodoModelItem {
  int? id;
  String? todo;
  bool? done;
  TodoModelItem({required this.id, required this.todo, this.done = false});

  void setDoneStatus(int doneStatus) {
    if (doneStatus == 0) {
      done = false;
    } else {
      done = true;
    }
  }
}
