import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task.dart';
import './list_item.dart';

//Parent widget of all ListItems, this widget role is just to group all list tiles.

class ListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskListProvider = Provider.of<TaskProvider>(context).getItemList();
    return FutureBuilder<List<Task>>(
        future: taskListProvider,
        builder: (context, taskList) {
          switch (taskList.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (taskList.hasError) return Text('Error: ${taskList.error}');
              return taskList.data.length > 0
                  ? ListView.builder(
                      itemCount: taskList.data.length,
                      itemBuilder: (context, index) {
                        return ListItem(taskList.data[index]);
                      },
                    )
                  : LayoutBuilder(
                      builder: (ctx, constraints) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: constraints.maxHeight * 0.5,
                                child: Image.asset('assets/images/waiting.png',
                                    fit: BoxFit.cover),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'No tasks added yet...',
                                style: Theme.of(context).textTheme.title,
                              ),
                            ],
                          ),
                        );
                      },
                    );
          }
        });
  }
}
