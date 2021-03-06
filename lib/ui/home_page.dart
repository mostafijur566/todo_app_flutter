import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/controller/task_controller.dart';
import 'package:todo_app_flutter/services/notification_services.dart';
import 'package:todo_app_flutter/services/theme_service.dart';
import 'package:todo_app_flutter/ui/theme.dart';
import 'package:todo_app_flutter/utils/dimensions.dart';
import 'package:todo_app_flutter/widgets/button.dart';

import '../models/task_model.dart';
import '../widgets/task_tile.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime _selectedDate = DateTime.now();

  final _taskController = Get.put(TaskController());
  var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    print(Dimensions.screenWidth);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: Dimensions.height10,),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks(){
    return Expanded(
        child: Obx((){
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _taskController.taskList.length,
              itemBuilder: (_, index){
              Task task = _taskController.reversedTaskList[index];

              if(task.repeat == 'Daily'){
                DateTime date = DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);

                notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task
                );

                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    )
                );
              }

              if(task.date==DateFormat.yMd().format(_selectedDate)){

                DateTime date = DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);

                notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]),
                    task
                );

                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                _showBottomSheet(context, task);
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    )
                );
              }

              else{
                return Container();
              }
            }
          );
        })
    );
  }

  _showBottomSheet(BuildContext context, Task task){
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1 ?
        MediaQuery.of(context).size.height * 0.24 :
        MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: Dimensions.height6,
              width: Dimensions.width120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.height10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]
              ),
            ),
            Spacer(),
            task.isCompleted == 1 ? Container() :
            _bottomSheetButton(
                label: 'Task Completed',
                onTap: (){
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                color: primaryClr,
                context: context
            ),

            _bottomSheetButton(
                label: 'Delete Task',
                onTap: (){
                  _taskController.delete(task);
                  Get.back();
                },
                color: Colors.red[400]!,
                context: context
            ),

            SizedBox(height: Dimensions.height10,),
            _bottomSheetButton(label: 'Close', onTap: (){}, color: Colors.red[400]!, context: context, isClose: true),
            SizedBox(height: Dimensions.height10,),
          ],
        ),
      )
    );
  }

  _bottomSheetButton({required String label, required Function() onTap, required Color color, bool isClose = false, required BuildContext context}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Dimensions.height4,),
        height: Dimensions.height55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isClose == true ? Colors.transparent : color,
          border: Border.all(
            width: Dimensions.width2,
            color: isClose == true ? Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]! : color
          ),
          borderRadius: BorderRadius.circular(Dimensions.height20)
        ),
        child: Center(
            child: Text(
                label,
              style: isClose == true ? titleStyle : titleStyle.copyWith(color: Colors.white),
            )
        ),
      ),
    );
  }

  _addDateBar(){
    return Container(
      margin: EdgeInsets.only(top: Dimensions.height20, left: Dimensions.width20,),
      child: DatePicker(
        DateTime.now(),
        height: Dimensions.height100,
        width: Dimensions.width80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: Dimensions.font20,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: Dimensions.font14,
                fontWeight: FontWeight.w600,
                color: Colors.grey
            )
        ),
        onDateChange: (date){
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar(){
    return Container(
      margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, top: Dimensions.height20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style:subHeadingStyle ,
                ),
                Text("Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(label: '+ Add Task', onTap: () async{
            await Get.to(AddTaskPage());
            _taskController.getTasks();
          })
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed!",
            body: Get.isDarkMode ? "Light theme activated" : "Dark theme activated"
          );

        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: Dimensions.height20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
