import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:cnct/utilities/colors.dart';
import 'package:cnct/models/reminder_db.dart';
import 'package:cnct/widgets/reminder_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cnct/views/body_widgets/no_birthdays_body.dart';
import 'package:cnct/widgets/edit_reminder_modal.dart';
class UpcomingBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    ScreenUtil.init(context,
        designSize: Size(width, height));
    return Expanded(
      child: Container(
          height: 550.0.h,
          child: Consumer<ReminderDB>(
            builder: (context, reminderDB, child) {
               return ( reminderDB.upcomingList.isNotEmpty) ? ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                    final simple = reminderDB.reminderList[reminderDB.upcomingList[index]];
                      return GestureDetector(
                        onTap: (){editReminder(context, simple, colorsList[index%colorsList.length]);},
                        child: ReminderTile(
                          title: simple.name,
                          description: simple.msg,
                          date: simple.date,
                          time: simple.time,
                          isChecked: simple.isDone,
                          checkBoxCallBack: (checkBoxState) {
                            reminderDB.updateReminder(simple);
                          },
                          deleteCallBack: (context) {
                            reminderDB.deleteReminder(simple, index, simple.id);
                          },
                          messageFunc: (context){
                            reminderDB.launchMessage(simple.number, simple.msg);
                          },
                          shareFunc: (context){
                            reminderDB.launchShare(simple.msg);
                          },
                          color: colorsList[index%colorsList.length]
                        ),
                      );
                  
              
                },
                
                itemCount: reminderDB.upcomingList.length,
              ): NoBirthdaysBody();
            },
           ) 
          ),
    );
  }
}
