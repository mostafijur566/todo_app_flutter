import 'package:flutter/material.dart';

import '../ui/theme.dart';

class CustomRowWidget extends StatelessWidget {
  const CustomRowWidget({Key? key, required this.label, required this.icon}) : super(key: key);
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.white,),
        SizedBox(width: 10,),
        Text(label,
          style: titleStyle.copyWith(fontSize: 24, color: Colors.white),
        ),
      ],
    );
  }
}
