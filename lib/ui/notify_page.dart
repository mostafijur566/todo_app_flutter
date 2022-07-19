import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:todo_app_flutter/ui/theme.dart';
import 'package:todo_app_flutter/widgets/custom_row_widget.dart';

class NotifyPage extends StatelessWidget {
  const NotifyPage({Key? key, required this.label}) : super(key: key);
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Get.isDarkMode ? Colors.white : Colors.grey,),
        ),
        title: Text(label!.split('|')[0], style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),),
      ),

      body: Center(
        child: Container(

          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: int.parse(label!.split("|")[2]) == 0 ? primaryClr : int.parse(label!.split("|")[2]) == 1 ? pinkClr : yellowClr
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomRowWidget(label: 'Title', icon: Icons.label),
              SizedBox(height: 10,),
              Text( label!.split('|')[0], style: TextStyle(color: Colors.white,
          fontSize: 18, ),),
              SizedBox(height: 20,),
              CustomRowWidget(label: 'Description', icon: Icons.description),
              SizedBox(height: 10,),
              Text( label!.split('|')[1], style: TextStyle(color: Colors.white,
                fontSize: 18, ),),
              SizedBox(height: 20,),
              CustomRowWidget(label: 'Time', icon: Icons.access_time_rounded),
              SizedBox(height: 10,),
              Text( label!.split('|')[3], style: TextStyle(color: Colors.white,
                fontSize: 18, ),),
            ],
          ),
        ),
      ),
    );
  }
}
