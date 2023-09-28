import 'package:flutter/material.dart';

import '../db/my_db.dart';
import 'todo.dart';

class TodoModel extends ChangeNotifier {
  List<TodoModelItem>? todo;
  bool _dataChanged = false;
  bool get dataChanged => _dataChanged;

  Future<List<TodoModelItem>> todoItems() async {
    if (todo!.isEmpty) await refreshTodoList();

    return todo!;
  }

  Future<void> refreshTodoList() async {
    List<Map<String, dynamic>> tempTodo;

    todo = [];
    tempTodo = await SQLHelper.getItems();
    formatQuerySet(tempTodo);
  }

  void formatQuerySet(List<Map<String, dynamic>> tempTodo) {
    if (tempTodo.isEmpty) return print('empty db');
    todo = [];
    for (var i = 0; i < tempTodo.length; i++) {
      // create new Instance of todomodelitem and append to list
      TodoModelItem todoModelItem =
          TodoModelItem(id: tempTodo[i]['id'], todo: tempTodo[i]['todo']);

      todoModelItem.setDoneStatus(tempTodo[i]['done']);
      todo?.add(todoModelItem);
    }
    _dataChanged = true;
  }

  Future<void> tick(int id) async {
    await SQLHelper.toggleTodoItem(id);
    refreshTodoList();
    _dataChanged = true;
    notifyListeners();
  }

  void createTodo(String todo) async {
    await SQLHelper.createItem(todo);

    _dataChanged = true;

    refreshTodoList();
  }

  Future<void> deleteTodo(int id) async {
    SQLHelper.deleteItem(id).then((value) => {refreshTodoList()});
    _dataChanged = true;
  }

  void deleteAll() {
    SQLHelper.deleteAllItems()
        .then((_) => refreshTodoList())
        .then((_) => notifyListeners());
    _dataChanged = true;
  }

  void search(String? txt) {
    txt ??= '';

    SQLHelper.searchBy(txt).then(
      (value) => formatQuerySet(value),
    );
    _dataChanged = true;
    notifyListeners();
  }

  void resetDataChanged() {
    _dataChanged = false;
  }
}
