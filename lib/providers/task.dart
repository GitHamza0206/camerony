import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Everything the user adds to the list is a task.
//Task provider is self explanatory and its job is being the provider for the project.

class Task {
  final String id;
  String description;
  String betAmount;
  DateTime dueDate;
  TimeOfDay dueTime;
  bool isDone;

  Task({
    this.id,
    @required this.description,
    this.betAmount,
    this.dueDate,
    this.dueTime,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': this.description,
      'betAmount': this.betAmount,
      'dueDate': DateTime(this.dueDate.year, this.dueDate.month,
          this.dueDate.day, this.dueTime.hour, this.dueTime.minute),
      'isDone': this.isDone,
    };
  }

  factory Task.fromMap(Map data) {
    return Task(
      description: data['description'] ?? 'No task',
      betAmount: data['betAmount'] ?? '0.0',
      dueDate: data['dueDate'].toDate(),
      /*dueTime: TimeOfDay.fromDateTime(
          DateTime.fromMicrosecondsSinceEpoch(data['dueDate'])),*/
      isDone: data['isDone'] ?? false,
    );
  }

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Task(
        id: doc.documentID,
        description: data['description'] ?? 'No task',
        betAmount: data['betAmount'] ?? '0.0',
        dueDate: data != null ? data['dueDate'].toDate() : null,
        dueTime: data != null
            ? TimeOfDay.fromDateTime(data['dueDate'].toDate())
            : null,
        isDone: data['isDone'] ?? false);
  }

  static List<Task> _listTask = [];
}

class TaskProvider with ChangeNotifier {
  List<Task> _toDoList = [];
  final _instance = Firestore.instance;

  Future<List<Task>> getItemList() async {
    _toDoList = [];
    List<Task> _list = [];
    var _snap = await _instance
        .collection('users')
        .document('tVNgNoxNjhdusdT0BNL0Sfd86Kt2')
        .collection('task')
        .getDocuments()
        .then((value) => value.documents.forEach((element) {
              _list.add(Task.fromFirestore(element));
              _toDoList.add(Task.fromFirestore(element));
            }));

    return _list;
  }

  Task getById(String id) {
    return _toDoList.firstWhere((task) => task.id == id);
  }

  String createId() {
    return _toDoList.length.toString();
  }

  void createNewTask(Task task) {
    final newTask = Task(
      description: task.description,
      betAmount: task.betAmount,
      dueDate: task.dueDate,
      dueTime: task.dueTime,
    );

    _instance
        .collection('users')
        .document('tVNgNoxNjhdusdT0BNL0Sfd86Kt2')
        .collection('task')
        .document(task.id)
        .setData(task.toJson());
    notifyListeners();
  }

  void editTask(Task task) {
    removeTask(task.id);
    createNewTask(task);
  }

  void removeTask(String id) {
    _instance
        .collection('users')
        .document('tVNgNoxNjhdusdT0BNL0Sfd86Kt2')
        .collection('task')
        .document(id)
        .delete();
    notifyListeners();
  }

  void changeStatus(String id) {
    int index = _toDoList.indexWhere((task) => task.id == id);
    _toDoList[index].isDone = !_toDoList[index].isDone;
    editTask(_toDoList[index]);
    //print('PROVIDER ${_toDoList[index].isDone.toString()}');
  }

  Future getNbTask() async {
    var _snap = _instance
        .collection('users')
        .document('tVNgNoxNjhdusdT0BNL0Sfd86Kt2')
        .collection('task')
        .getDocuments();

    if (_snap != null) {
      return _snap;
    }
    return null;
  }

  Future getDoneTask() async {
    var _snap = await _instance
        .collection('users')
        .document('tVNgNoxNjhdusdT0BNL0Sfd86Kt2')
        .collection('task')
        .where('isDone', isEqualTo: true)
        .getDocuments();

    if (_snap != null) {
      return _snap;
    }
    return null;
  }

  Future getPendingTask() async {
    var _snap = await _instance
        .collection('users')
        .document('tVNgNoxNjhdusdT0BNL0Sfd86Kt2')
        .collection('task')
        .where('isDone', isEqualTo: false)
        .getDocuments();
    return _snap;
  }

  Future getWonAmount() async {
    int res = 0;

    var _snap = await _instance
        .collection('users')
        .document('tVNgNoxNjhdusdT0BNL0Sfd86Kt2')
        .collection('task')
        .where('isDone', isEqualTo: false)
        .snapshots()
        .listen((event) {
      event.documents.forEach((element) {
        res = res + int.parse(element.data['betAmount']);
      });
    });
    return res;
  }
}
