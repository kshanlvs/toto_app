class TodoModel {
  String? taskTitle;
  String? taskDescription;
  String? taskTime;
  String? userId;
  String? taskId;
  bool? taskCompleted;
  String? userEmail;

  TodoModel({this.taskDescription,this.taskTime,this.taskTitle,this.taskId,this.userEmail});

  TodoModel.formJson(Map<String,dynamic> json) {
    taskTitle = json['task_title'];
    taskDescription = json['task_desc'];
    taskTitle = json['task_time'];
    userId = json['user_id'];
    taskId = json['task_id'];
    taskCompleted = json['task_completed'];
    userEmail = json['email'];
    }

  Map<String,dynamic>  toJson() {
   Map<String,dynamic> data = {};

   data['task_title'] = taskTitle;
   data['task_desc'] = taskDescription;
   data['task_time'] = taskTime;
   data['user_id'] = userId;
   data['task_id'] = taskId;
   data['task_completed'] = taskCompleted;
   data['email'] = userEmail;

   return data;
  }
}