import 'package:flutter/material.dart';
import 'package:todo_app_flutter/ui/theme.dart';
import 'package:todo_app_flutter/utils/dimensions.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Dimensions.width120,
        height: Dimensions.height50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.height20),
          color: primaryClr
        ),

        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
