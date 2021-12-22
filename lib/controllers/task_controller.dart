import 'package:get/get.dart';
import 'package:to_do_list_v2/db/db_helper.dart';
import 'package:to_do_list_v2/models/tasks.dart';
import 'package:query/query.dart';

class TaskController extends GetxController{
  @override
  void onReady(){
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTasks() async{
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
    print('tasks are here');
  }

  void delete(Task task){
    DBHelper.delete(task);
  }
}