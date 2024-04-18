import 'package:cnct/models/reminder_db.dart';
import 'package:cnct/utilities/constants.dart';
import 'package:cnct/views/body_widgets/todays_birthdays.dart';
import 'package:cnct/views/body_widgets/upcoming_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'body_widgets/no_birthdays_body.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RemindersView extends StatefulWidget {
  @override
  _RemindersViewState createState() => _RemindersViewState();
}

class _RemindersViewState extends State<RemindersView> {
  String greeting = 'Good Day';
  bool _tab = true;
  bool _remindersExist = false;
  void getGreeting() {
    TimeOfDay now = TimeOfDay.now();

    greeting = (now.hour <= 12
        ? 'Good Morning'
        : (now.hour <= 17 ? 'Good Afternoon' : 'Good Evening'));
  }

  void checkIfRemindersExist() {
      
      Provider.of<ReminderDB>(context, listen:false).sortReminderList();
      Provider.of<ReminderDB>(context).updateTodaysList();
      Provider.of<ReminderDB>(context).getUpcomingList();

      _remindersExist = Provider.of<ReminderDB>(context).todaysList.isNotEmpty;
  }

  
  @override
  void initState() {
    getGreeting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(432.0, 816.0));
    checkIfRemindersExist();

    return Padding(
      padding: EdgeInsets.only(left: 20.0.w, right: 20.0.w, top: 5.0.h),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Hello, $greeting!',
                  style: TextStyle(
                    fontSize: 25.5.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'WorkSans',
                  ),
                ),
              ),
              SizedBox(height: 2.0.h),
              Text(
                'You have ${Provider.of<ReminderDB>(context).todaysList.length} birthday(s) for today.',
                style: TextStyle(
                  fontSize: 20.0.sp,
                  fontFamily: 'WorkSans',
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 3.0.h),

            ],
          ),
          Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 44.0.w),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _tab = true;
                          });
                        },
                        child: Text(
                          'TODAY',
                          style: _tab
                              ? kActiveTextStyle
                              : kInactiveTextStyle,
                        ),
                      ),
                      SizedBox(width: 108.0.w),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _tab = false;
                          });
                        },
                        child: Text(
                          'UPCOMING',
                          style: _tab
                              ? kInactiveTextStyle
                              : kActiveTextStyle,
                        ),
                      ),
                    ],
                  ),
                  
                ],
              ),
            (_tab) ? 
                (_remindersExist) ?
                    TodaysBirthdays()
                    : NoBirthdaysBody()
                : UpcomingBody(),
        ],
      ),
    );
  }
}
