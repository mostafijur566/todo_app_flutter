import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/controller/task_controller.dart';
import 'package:todo_app_flutter/ui/theme.dart';
import 'package:todo_app_flutter/utils/dimensions.dart';
import 'package:todo_app_flutter/widgets/button.dart';
import 'package:todo_app_flutter/widgets/input_field.dart';

import '../models/task_model.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  final TaskController _taskController = Get.put(TaskController());

  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = "9:30 PM";
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20
  ];

  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
  ];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Task',
                style: headingStyle,
              ),
              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
              MyInputField(title: "Note", hint: "Enter your note", controller: _noteController,),
              MyInputField(title: "Date", hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: (){
                    _getDateFromUser();
                  },
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey 
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(child: MyInputField(title: 'Start Time',
                      hint: _startTime,
                    widget: IconButton(
                      onPressed: (){
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                  SizedBox(width: Dimensions.width12,),
                  Expanded(child: MyInputField(title: 'End Time',
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: (){
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                ],
              ),
              MyInputField(title: 'Remind', hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: Dimensions.height32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  },
                ),
              ),

              MyInputField(title: 'Repeat', hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: Dimensions.height32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  items: repeatList.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRepeat = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: Dimensions.height18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPlate(),
                  MyButton(label: "Create Task", onTap: (){
                    _validateData();
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData(){
    if(_titleController.text.isEmpty){
      Get.snackbar(
          'Required!',
          'Title field is required!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.isDarkMode ? Colors.white : darkHeaderClr,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red,),
        colorText: Colors.red
      );
    }

    else if(_noteController.text.isEmpty){
      Get.snackbar(
          'Required!',
          'Note field is required!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.isDarkMode ? Colors.white : darkHeaderClr,
          icon: Icon(Icons.warning_amber_rounded, color: Colors.red,),
          colorText: Colors.red
      );
    }

    else{
      _addTaskToDB();
      Get.back();
    }
  }

  _addTaskToDB() async{
    int value = await _taskController.addTask(task: Task(
      note: _noteController.text,
      title: _titleController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0,
    ));
    print('id $value');
  }

  _colorPlate(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color",
          style: titleStyle,
        ),
        SizedBox(height: Dimensions.height8,),
        Wrap(
            children: List<Widget>.generate(
                3,
                    (int index){
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: Padding(padding: EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        radius: Dimensions.height14,
                        backgroundColor: index == 0 ? primaryClr : index == 1 ? pinkClr : yellowClr,
                        child: _selectedColor == index ? Icon(Icons.done,
                          color: Colors.white,
                          size: Dimensions.height16,
                        ) : Container(),
                      ),
                    ),
                  );
                }
            )
        )
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: Dimensions.height20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          size: Dimensions.height20,
        ),
        SizedBox(width: Dimensions.width20,),
      ],
    );
  }
  
  _getDateFromUser() async{
    DateTime ? _pickerDate = await showDatePicker(context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(int.parse(DateFormat.y().format(DateTime.now()).toString()) - 1),
        lastDate: DateTime(int.parse(DateFormat.y().format(DateTime.now()).toString()) + 1),
    );

    if(_pickerDate != null){
      setState(() {
        _selectedDate = _pickerDate;
      });

    }

  }

  _getTimeFromUser({required bool isStartTime}) async{
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime == null){
      print("time canceled");
    }
    else if(isStartTime == true){
      setState(() {
        _startTime = _formatedTime;
      });
    }
    else if(isStartTime == false){
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        )
    );
  }
}
