import 'package:flutter/material.dart';
import 'package:todo_app_flutter/utils/dimensions.dart';

import '../ui/theme.dart';

class CustomRowWidget extends StatelessWidget {
  const CustomRowWidget({Key? key, required this.label, required this.icon}) : super(key: key);
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: Dimensions.height24, color: Colors.white,),
        SizedBox(width: Dimensions.width10,),
        Text(label,
          style: titleStyle.copyWith(fontSize: Dimensions.height24, color: Colors.white),
        ),
      ],
    );
  }
}
