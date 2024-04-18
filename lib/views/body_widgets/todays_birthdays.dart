import 'package:cnct/models/reminder_db.dart';
import 'package:cnct/widgets/reminder_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cnct/utilities/colors.dart';
import 'package:cnct/widgets/edit_reminder_modal.dart';
class TodaysBirthdays extends StatefulWidget {


  @override
  State<TodaysBirthdays> createState() => _TodaysBirthdaysState();
}

class _TodaysBirthdaysState extends State<TodaysBirthdays> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
       GlobalKey<RefreshIndicatorState>();
  

  Future<void> _rebuild(BuildContext context) async {
    setState((){
      Provider.of<ReminderDB>(context, listen:false).sortReminderList();
      Provider.of<ReminderDB>(context, listen:false).updateTodaysList();
      Provider.of<ReminderDB>(context, listen: false).getUpcomingList();
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    ScreenUtil.init(context,
        designSize: Size(width, height));
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: ()async { _rebuild(context);},
        child: Container(
          height: 550.0.h,
          child: Consumer<ReminderDB>(
            builder: (context, reminderDB, child) {
              
              return ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.only(top: 10.0.h, bottom:120.h ),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                    final simple = reminderDB.reminderList[reminderDB.todaysList[index]];
                      return GestureDetector(
                        onTap: (){
                          editReminder(context, simple, colorsList[index%colorsList.length]);
                        },
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
                
                itemCount: reminderDB.todaysList.length,
              );
            },
           ) 
          )
        ),
    );
  }
}
