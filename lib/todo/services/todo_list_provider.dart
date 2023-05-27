import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toto_app/auth/services/token_service.dart';
import 'package:toto_app/todo/models/todo_add_model.dart';
import 'package:uuid/uuid.dart';

class TodoListCrudProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  DateTime? selectedDate;

  Future addNewTask(TodoModel todoModel) async {
    todoModel.userId = await TokenService.getToken();
    todoModel.taskId = generateUUID();
    todoModel.taskCompleted = false;
    await db.collection("todo_list").add(todoModel.toJson());
  }

  String generateUUID() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  Future<bool> deleteTask(String taskId) async {
    db
        .collection("todo_list")
        .where("task_id", isEqualTo: taskId)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete().then((_) {
          const SnackBar(content: Text("Deleted Successful"));
        }).catchError((error) {
          const SnackBar(content: Text("Something went wrong"));
        });
      }
    }).catchError((error) {
      throw Exception(error.toString());
    });

    return true;
  }

  int completedCount = 0;
  int pendingCount = 0;
  bool isLoading=false;

  Future<int> getCompletedTaskCount(String email) async {

  isLoading = true;
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('todo_list')
        .where('email', isEqualTo: email)
        .where('task_completed', isEqualTo: true)
        .get();
    final QuerySnapshot pendingSnapShot = await FirebaseFirestore.instance
        .collection('todo_list')
        .where('email', isEqualTo: email)
        .where('task_completed', isEqualTo: false)
        .get();
    completedCount = snapshot.docs.length;
    pendingCount = pendingSnapShot.docs.length;
    isLoading = false;
    notifyListeners();
    int count = snapshot.docs.length;
    return count;
  }

  Future editTask(String taskId,
      {required String title,
      required String desc,
      required String time}) async {
    db
        .collection("todo_list")
        .where("task_id", isEqualTo: taskId)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference
            .update({
              "task_desc": desc,
              "task_title": title,
              "task_time": time,
            })
            .then((_) {})
            .catchError((error) {});
      }
    }).catchError((error) {});
  }

  void updateTaskCompleted(bool val, String taskId) {
    db
        .collection("todo_list")
        .where("task_id", isEqualTo: taskId)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference
            .update({"task_completed": val})
            .then((_) {})
            .catchError((error) {});
      }
    }).catchError((error) {});
  }
}
