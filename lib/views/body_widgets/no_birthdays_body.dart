import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoBirthdaysBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    ScreenUtil.init(context,
        designSize: Size(_width, _height));
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.0.h),
          child: Image.asset(
            'assets/images/noreminder.png',
            width: double.maxFinite.w,
          ),
        ),
        Text(
          'No Bdays',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'WorkSans',
          ),
        ),
        SizedBox(height: 5.0.h),
        Text(
          'Add a Birthday and it will',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0.sp,
            fontFamily: 'WorkSans',
            color: Colors.grey[500],
          ),
        ),
        Text(
          'show up here',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0.sp,
            fontFamily: 'WorkSans',
            color: Colors.grey[500],
          ),
        ),
        SizedBox(height: 1.0.h),
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[500],
        ),
      ],
    );
  }
}
