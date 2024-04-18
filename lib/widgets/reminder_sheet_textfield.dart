import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ReminderSheetTextField extends StatelessWidget {
  final TextEditingController taskTextController;
  String text;
  final String helperText;
  final String hintText;
   ReminderSheetTextField({required this.taskTextController, this.text = "", this.helperText = "", this.hintText = ""});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(432.0, 816.0));

    return TextField(
      controller: taskTextController,
      autocorrect: true,
      // autofocus:
      //     true, //To automatically enable the textfield and show keyboard
      decoration: InputDecoration(
        helperText: helperText,
        hintText: hintText,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0.h),
          borderSide: const BorderSide(
            color:  Color.fromARGB(255, 189, 189, 189),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0.h),
          borderSide: const BorderSide(
            color:  Color.fromARGB(255, 177, 174, 174),
          ),
        ),
      ),
      onChanged: (value) {
        text = value;
      },
      
      
    );
  }
}
