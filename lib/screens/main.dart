import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../models/todo.dart';
import '../themes.dart';
import '../widgets/widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController search = TextEditingController();

  final TextEditingController todo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TodoModel>(context, listen: false);

    provider.refreshTodoList();

    return Stack(
      children: [
        Positioned(
          top: 0, // Adjust this value as needed
          left: 0,
          right: 0,
          bottom: 60,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // *search box
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    onChanged: (String text) {
                      provider.search(search.text);
                    },
                    controller: search,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(Icons.search, color: tdBlack),
                      hintText: 'search',
                      hintStyle: TextStyle(color: tdBlack),
                      border: InputBorder.none,
                      prefixIconConstraints:
                          BoxConstraints(maxHeight: 20, minWidth: 25),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'All ToDos',
                    style: TextStyle(
                        color: tdBlack,
                        fontSize: 30,
                        fontFamily: 'LuckiestGuy',
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Consumer<TodoModel>(
                  builder: (context, todoModel, child) {
                    if (todoModel.dataChanged) {
                      todoModel.resetDataChanged();
                    }
                    final todo = todoModel.todo;

                    return FutureBuilder<List<TodoModelItem>>(
                      future: provider.todoItems(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<TodoModelItem>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          Iterable<TodoModelItem> results =
                              snapshot.data!.reversed;
                          if (results.isEmpty) {
                            return const Center(
                                child: Text(
                              'No Notes Yet',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ));
                          }
                          return Column(
                            children: results.map((result) {
                              return TodoItem(
                                todoModel: result,
                                onDelete: () {
                                  int id = result.id!;
                                  provider
                                      .deleteTodo(id)
                                      .then((value) => setState(() {}));
                                },
                                onclick: () {
                                  int id = result.id!;
                                  provider
                                      .tick(id)
                                      .then((value) => setState(() {}));
                                },
                              );
                            }).toList(),
                          );
                        }
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin:
                      const EdgeInsets.only(right: 20, bottom: 20, left: 20),
                  child: TextField(
                    controller: todo,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'add todo...'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (todo.text.isNotEmpty) {
                    provider.createTodo(todo.text);
                    todo.text = '';
                  }
                  setState(() {});
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  decoration: BoxDecoration(
                      color: tdBlue, borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                      '+',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
