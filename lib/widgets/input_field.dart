import 'package:flutter/material.dart';
import 'package:todo_app_flutter/ui/theme.dart';
import 'package:get/get.dart';
import 'package:todo_app_flutter/utils/dimensions.dart';

class MyInputField extends StatelessWidget {
  const MyInputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.height16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: Dimensions.height52,
            margin: EdgeInsets.only(top: Dimensions.height8),
            padding: EdgeInsets.only(left: Dimensions.width14, right: Dimensions.width14),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: Dimensions.width1),
                borderRadius: BorderRadius.circular(Dimensions.height12)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.backgroundColor,
                          width: 0
                        )
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: context.theme.backgroundColor,
                              width: 0
                          )
                      ),
                    ),
                  ),
                ),
                widget == null ? Container() : Container(child: widget,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
