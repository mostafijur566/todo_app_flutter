import 'package:get/get.dart';
import 'package:todo_app_flutter/db/db_helper.dart';

import '../models/task_model.dart';

class TaskController extends GetxController{

  @override
  void onReady() {
    super.onReady();

  }

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task!);
  }

}