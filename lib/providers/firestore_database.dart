import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'task.dart';

class FirestoreDatabase {
  // implementation omitted for brevity2

  final _instance = Firestore.instance;

  void addTask(Task task) {
    print(task.toJson());
    _instance
        .collection('users')
        .document('tVNgNoxNjhdusdT0BNL0Sfd86Kt2')
        .collection('task')
        .document(task.id)
        .setData(task.toJson());
  }

  Future getNbTask() async {
    var _snap = await _instance
        .collection('users')
        .document('tVNgNoxNjhdusdT0BNL0Sfd86Kt2')
        .collection('task')
        .snapshots()
        .length;
    return _snap;
  }
}

class FirestoreDatabaseProvider with ChangeNotifier {
  final _instance = Firestore.instance;

  Future<int> getNbTask() async {
    var _snap = await _instance
        .collection('users')
        .document('tVNgNoxNjhdusdT0BNL0Sfd86Kt2')
        .collection('task')
        .snapshots()
        .length;
    return _snap;
  }
}
