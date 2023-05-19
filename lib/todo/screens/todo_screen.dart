import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toto_app/auth/screens/login_page.dart';
import 'package:toto_app/auth/services/token_service.dart';
import 'package:toto_app/todo/models/todo_add_model.dart';
import 'package:toto_app/todo/services/todo_list_provider.dart';
import 'package:toto_app/widgets/loder.dart';

import '../../auth/services/google_sign_in_provider.dart';

class TodoPage extends StatefulWidget {
  final String userEmail;
  const TodoPage({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  String? token;

  @override
  void initState() {
    token = "";
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> getDataStream() {
      // Replace 'collectionName' with the name of your collection in Firestore
      CollectionReference<Map<String, dynamic>> collectionRef =
          FirebaseFirestore.instance.collection('todo_list');

      // Apply filter criteria using the 'where' method
      Query<Map<String, dynamic>> query =
          collectionRef.where('email', isEqualTo: widget.userEmail);

      // Return the query snapshot as a stream
      return query.snapshots();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () async {
                if (await context
                    .read<GoogleSignInProvider>()
                    .signOutFromGoogle()) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const GoogleLoginPage();
                      },
                    ),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.logout,
                  color: Color(0xFFc56358),
                ),
              ))
        ],
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(.1),
        backgroundColor: Colors.white,
        title: const Text(
          'Todo List',
          style:
              TextStyle(color: Color(0xFFc56358), fontWeight: FontWeight.w400),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: RoundedButton(
                    onTapButton: () {
                      showCustomDialog(
                        context,
                        context.read<TodoListCrudProvider>(),
                      );
                    },
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: getDataStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator while data is being fetched
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Text('No data found.');
                } else {
                  final List<DocumentSnapshot<Map<String, dynamic>>> documents =
                      snapshot.data!.docs;

                  if (documents.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/noData.jpg",
                            height: 400,
                            width: 500,
                          ),
                          const Text(
                            "Oops!! No Task Added.",
                            style: TextStyle(
                                color: Color(0xFFc56358), fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot<Map<String, dynamic>>
                              document = documents[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.3), //New
                                    blurRadius: 10.0,
                                  )
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                document.data()?['task_title'],
                                                style: TextStyle(
                                                    decoration: document
                                                                .data()?[
                                                            'task_completed']
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : null,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              if (await context
                                                  .read<TodoListCrudProvider>()
                                                  .deleteTask(
                                                      document['task_id'])) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Successfully deleted task"),
                                                  ),
                                                );
                                              }
                                            },
                                            icon: const Icon(Icons.delete),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showCustomDialog(
                                                  context,
                                                  context.read<
                                                      TodoListCrudProvider>(),
                                                  data: document);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Color(0xFFc56358),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, bottom: 5),
                                        child: Text(
                                          document.data()?['task_desc'],
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey),
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              document.data()?['task_time'],
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Color(0xFFc56358)),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Checkbox(
                                                  value: document.data()?[
                                                      'task_completed'],
                                                  onChanged: (val) {
                                                    context
                                                        .read<
                                                            TodoListCrudProvider>()
                                                        .updateTaskCompleted(
                                                            val!,
                                                            document[
                                                                "task_id"]);
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                          // return ShadowedWidget();
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context, TodoListCrudProvider provider,
      {DocumentSnapshot<Map<String, dynamic>>? data}) {
    TextEditingController dateController = TextEditingController();
    TextEditingController taskTitle = TextEditingController();
    TextEditingController taskDescription = TextEditingController();
    if (data != null) {
      dateController.text = data['task_time'];
      taskTitle.text = data['task_title'];
      taskDescription.text = data['task_desc'];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: taskTitle,
                    decoration: InputDecoration(
                      hintText: 'title...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: taskDescription,
                    decoration: InputDecoration(
                      hintText: 'description...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context, dateController);
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_month),
                          hintText: 'date..',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      OrangeLoaderOverlay.show(context);
                      if (data != null) {
                        await provider.editTask(data['task_id'],
                            time: dateController.text,
                            title: taskTitle.text,
                            desc: taskDescription.text);
                      } else {
                        TodoModel todoModel = TodoModel(
                            userEmail: widget.userEmail,
                            taskDescription: taskDescription.text,
                            taskTime: dateController.text,
                            taskTitle: taskTitle.text);
                        await provider.addNewTask(todoModel);
                      }
                      OrangeLoaderOverlay.hide();

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(data != null
                              ? "Task Edited Successfully!!"
                              : "Task Added Successfully!!")));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          data != null ? 'Update' : "Add",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('dd MMMM yyyy').format(pickedDate);
    }
  }

  getToken() async {
    token = await TokenService.getToken();
  }
}

class RoundedButton extends StatelessWidget {
  final Function() onTapButton;
  const RoundedButton({super.key, required this.onTapButton});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        onTapButton();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFc56358),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: const Text(
        'Add Task',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
