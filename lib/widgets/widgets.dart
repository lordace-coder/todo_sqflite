import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../themes.dart';

class TodoItem extends StatelessWidget {
  const TodoItem(
      {super.key,
      required this.todoModel,
      required this.onDelete,
      required this.onclick});
  final TodoModelItem todoModel;
  final VoidCallback onclick;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final String todo = todoModel.todo!;
    final bool done = todoModel.done!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(32.2)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onclick,
                icon: Icon(
                  done ? Icons.check_box : Icons.check_box_outline_blank,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: Text(
                  todo,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 19.5,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500),
                ),
              ),
              InkWell(
                onTap: onDelete,
                child: Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                      color: tdRed, borderRadius: BorderRadius.circular(20)),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

PopupMenuItem createItem(IconData icon, String text, VoidCallback? onClick) {
  return PopupMenuItem(
    onTap: onClick,
    child: Row(
      children: [
        Icon(
          icon,
          color: tdBlack,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(text)
      ],
    ),
  );
}
