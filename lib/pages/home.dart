import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../screens/main.dart';
import '../themes.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TodoModel provider = Provider.of<TodoModel>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: tdBGColor,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) => [
                    createItem(
                      Icons.delete,
                      'delete all',
                      () {
                        provider.deleteAll();
                      },
                    )
                  ],
                  child: const Icon(
                    Icons.menu_rounded,
                    size: 30,
                    color: tdBlack,
                  ),
                ),
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage('assets/lordace.png'),
                )
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const MainPage(),
      ),
    );
  }
}
