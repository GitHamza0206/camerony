import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:to_do_list/widgets/overview_box.dart';
import 'package:to_do_list/widgets/plaid.dart';

import '../widgets/add_new_task.dart';
import '../widgets/list.dart';

//Homepage of the app. It allows the user to insert new tasks to his list.
//It'll allow the user to add new lists too (later features).

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  List<Widget> _children = [
    OverviewBox(),
    ListWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TO DO LIST'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => PlaidWidget()));
            },
          ),
        ],
      ),
      body: _children[_selectedIndex],
      floatingActionButton: Opacity(
        opacity: _selectedIndex == 0 ? 0 : 1,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => AddNewTask(isEditMode: false),
            );
          },
          tooltip: 'Add a new item!',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), title: Text('Tasks'))
        ],
      ),
    );
  }
}
