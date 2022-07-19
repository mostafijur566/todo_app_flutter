import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_flutter/utils/dimensions.dart';

import '../models/task_model.dart';
import '../ui/theme.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: Dimensions.width20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: Dimensions.height12),
      child: Container(
        padding: EdgeInsets.only(top: Dimensions.height16, left: Dimensions.width16, right: Dimensions.width16, bottom: Dimensions.height16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.width16),
          color: _getBGClr(task?.color??0),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task?.title??"",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey[200],
                      size: Dimensions.height18,
                    ),
                    SizedBox(width: Dimensions.width4),
                    Text(
                      "${task!.startTime} - ${task!.endTime}",
                      style: GoogleFonts.lato(
                        textStyle:
                        TextStyle(fontSize: Dimensions.font13, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height12),
                Text(
                  task?.note??"",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: Dimensions.font15, color: Colors.grey[100]),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: Dimensions.width10),
            height: Dimensions.height60,
            width: Dimensions.width0dot5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task!.isCompleted == 1 ? "COMPLETED" : "TODO",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: Dimensions.font10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return blushClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return blushClr;
    }
  }
}