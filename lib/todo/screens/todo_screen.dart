import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:toto_app/auth/screens/login_page.dart';
import 'package:toto_app/color_constants.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> getDataStream() {
      CollectionReference<Map<String, dynamic>> collectionRef =
          FirebaseFirestore.instance.collection('todo_list');

      Query<Map<String, dynamic>> query =
          collectionRef.where('email', isEqualTo: widget.userEmail);

      return query.snapshots();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () {
          _showBottomSheet(context, context.read<TodoListCrudProvider>());
        },
        child: const Icon(Icons.add),
      ),
      drawer: Container(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: _buildAppBar(context),
      ),
      body: _buildBody(context, getDataStream),
    );
  }

  SafeArea _buildBody(BuildContext context,
      Stream<QuerySnapshot<Map<String, dynamic>>> Function() getDataStream) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const ListTile(
              contentPadding: EdgeInsets.only(top: 30, bottom: 2, left: 20),
              dense: true,
              leading: Text(
                "INBOX",
                style: TextStyle(color: Colors.grey),
              ),
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
                    ScaffoldMessenger.of(context).clearSnackBars();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/noData.jpg",
                            height: 300,
                            width: 300,
                          ),
                        ),
                        const Text(
                          "Oops!! No Task Added.",
                          style:
                              TextStyle(color: Color(0xFFc56358), fontSize: 20),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          child: ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot<Map<String, dynamic>>
                                  document = documents[index];

                              return Column(
                                children: [
                                  Slidable(
                                    startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          flex: 2,
                                          onPressed: (context) async {
                                            OrangeLoaderOverlay.show(context);
                                            if (await context
                                                .read<TodoListCrudProvider>()
                                                .deleteTask(document
                                                    .data()?['task_id'])) {
                                              OrangeLoaderOverlay.hide();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Task Deleted")));
                                            }
                                          },
                                          backgroundColor: primaryColor,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                        SlidableAction(
                                          flex: 2,
                                          onPressed: (context) async {
                                            _showBottomSheet(
                                                context,
                                                context.read<
                                                    TodoListCrudProvider>(),
                                                data: document);
                                          },
                                          backgroundColor:
                                              const Color(0xFF21B7CA),
                                          foregroundColor: Colors.white,
                                          icon: Icons.edit,
                                          label: 'Edit',
                                        ),
                                      ],
                                    ),
                                    key: ValueKey(index),
                                    child: ListTile(
                                        dense: false,
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color: const Color(0xffeeeeee),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.work_history,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                        title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                document.data()?['task_title'],
                                                style: TextStyle(
                                                  decoration: document.data()?[
                                                          'task_completed']
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : null,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                document.data()?['task_desc'],
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                            ]),
                                        trailing: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                document.data()?['task_time'],
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Theme(
                                                data: ThemeData(
                                                    checkboxTheme: CheckboxThemeData(
                                                        checkColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                        fillColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    primaryColor)),
                                                    primaryColor: primaryColor,
                                                    backgroundColor:
                                                        primaryColor,
                                                    unselectedWidgetColor:
                                                        primaryColor),
                                                child: Checkbox(
                                                  value: document.data()?[
                                                      'task_completed'],
                                                  onChanged: ((value) {
                                                    context
                                                        .read<
                                                            TodoListCrudProvider>()
                                                        .updateTaskCompleted(
                                                            value!,
                                                            document.data()?[
                                                                'task_id']);
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 8),
                                    child: Divider(
                                      thickness: 2,
                                      color: Color(0xffeeeeee),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          dense: true,
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Completed",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  color:
                                      primaryColor, // Set the background color
                                  shape: BoxShape
                                      .circle, // Set the shape to circle
                                ),
                                child: Center(
                                    child: FutureBuilder<int>(
                                  future: context
                                      .read<TodoListCrudProvider>()
                                      .getCompletedTaskCount(widget.userEmail),
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data.toString(),
                                      style: const TextStyle(
                                        color:
                                            Colors.white, // Set the text color
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                )),
                              )
                            ],
                          ),
                        )
                      ],
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

  void _showBottomSheet(BuildContext context, TodoListCrudProvider provider,
      {DocumentSnapshot<Map<String, dynamic>>? data}) {
    TextEditingController dateController = TextEditingController();
    TextEditingController taskTitle = TextEditingController();
    TextEditingController taskDescription = TextEditingController();
    if (data != null) {
      dateController.text = data['task_time'];
      taskTitle.text = data['task_title'];
      taskDescription.text = data['task_desc'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                primaryColor,
                Color.fromRGBO(91, 37, 8, 1),
              ], // Replace with your desired gradient colors
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          data != null ? "Edit your things" : 'Add new things',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        const Icon(
                          Icons.filter_list_off,
                          color: Colors.white,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Icon(
                          Icons.add_task_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: taskTitle,
                      cursorColor: Colors.grey,
                      decoration: _textFieldInputDecoration("Title"),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: taskDescription,
                      cursorColor: Colors.grey,
                      decoration: _textFieldInputDecoration("Description"),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context, dateController);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: dateController,
                          cursorColor: Colors.grey,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: "Time",
                            // border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
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

                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(data != null
                                  ? "Task Updated Successfully!!"
                                  : "Task Added Successfully!!")));
                        },
                        child:
                            Text(data != null ? "Update" : 'Add Your Things'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _textFieldInputDecoration(String labelText) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      labelText: labelText,
      // border: UnderlineInputBorder(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: FractionallySizedBox(
        heightFactor: 1.4, // Set the desired height factor (20%)
        child: Stack(
          children: const [
            BackGroundImage(),
            YouThingsWidget(),
            TaskOverViewWidget(),
          ],
        ),
      ),
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
    );
  }

  void _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('dd MMMM yyyy').format(pickedDate);
    }
  }
}

class TaskOverViewWidget extends StatelessWidget {
  const TaskOverViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Opacity(
        opacity: 0.5,
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.only(top: 110),
            child: Center(
              child: Consumer<TodoListCrudProvider>(
                builder: (context, value, child) {
                  double percentage = double.parse((value.completedCount /
                          (value.completedCount + value.pendingCount))
                      .toStringAsFixed(1));

                  if (value.isLoading) {
                    return CupertinoActivityIndicator();
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    value.completedCount.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  const Text(
                                    "Completed",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    value.pendingCount.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  const Text(
                                    "Pending",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Consumer<TodoListCrudProvider>(
                              builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                  ),
                                  child: CircularPercentIndicator(
                                    backgroundColor: Colors.white,
                                    radius: 20.0,
                                    lineWidth: 5.0,
                                    percent: double.parse(
                                      (value.completedCount /
                                              (value.completedCount +
                                                  value.pendingCount))
                                          .toStringAsFixed(1),
                                    ),
                                    progressColor: Colors.green[600],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${(percentage * 100).toStringAsFixed(0)} % Complete",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class YouThingsWidget extends StatelessWidget {
  const YouThingsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: primaryColor, width: 4))),
      width: MediaQuery.of(context).size.width / 2,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 80, top: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Things",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 30),
                child: Text(
                  DateFormat('MMMM, dd yyyy').format(DateTime.now()),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BackGroundImage extends StatelessWidget {
  const BackGroundImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/landingPage.jpg'), // Replace with your image path
          fit: BoxFit.cover,
        ),
      ),
    );
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
