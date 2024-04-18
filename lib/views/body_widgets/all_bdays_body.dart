// import 'package:checklst/models/check_if_user_logged_in.dart';
// import 'package:checklst/utilities/location_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cnct/models/reminder.dart';
import 'package:cnct/models/reminder_db.dart';
import 'package:cnct/widgets/reminder_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:cnct/utilities/colors.dart';
import 'package:cnct/widgets/edit_reminder_modal.dart';
class AllBdayBody extends StatefulWidget {
  final String searchQuery;
  
  AllBdayBody({this.searchQuery = ""});

  @override
  State<AllBdayBody> createState() => _AllBdayBodyState();
}

class _AllBdayBodyState extends State<AllBdayBody> {
  
  static const List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    ScreenUtil.init(context,
        designSize: Size(width, height));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
              children: [
                Text(
                  '${Provider.of<ReminderDB>(context).reminderList.length}',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                    fontSize: 25.5.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'WorkSans'
                  ),
                ),
                Text(
                  ' Birthdays',
                  style: TextStyle(
                    fontSize: 25.5.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'WorkSans'
                  ),
                ),
                SizedBox(width: 40.w),
                Expanded(
                  child: Container(
                    width: 150.w,
                    height: 50.h,
                    child: 
                    FloatingActionButton(
                  
                      backgroundColor: Colors.black,
                      onPressed: ()async { 
                        await Permission.contacts.request();
                        await Provider.of<ReminderDB>(context, listen:false).importAllContacts();
                        setState(() {
                        
                        }
                      );}, 
                      child: Text("Import Contacts",
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )
                    )
                  )
                  ),
                )
              ],
            ),
          
          SizedBox(height: 3.0.h),
          Expanded(
            child: Container(
              height: 500.h,
              child: Consumer<ReminderDB>(
                builder: (context, reminderDB, child) {
                  reminderDB.getRemindersPerMonth();
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.only(top: 10.0.h, bottom: 120.h),
                      shrinkWrap: true,
                      //months.length is 12
                      itemCount: 12,
                      itemBuilder: (context, monthIndex) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0.h),
                              child: 
                                Text(months[monthIndex],
                                  style: 
                                    TextStyle(
                                      fontSize: 20.0.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'WorkSans'
                                    )
                                )
                            ),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: reminderDB.monthLists[monthIndex].length,
                              itemBuilder:(context, index){
                                final rem = reminderDB.reminderList[reminderDB.monthLists[monthIndex][index]];
                                if (rem.name.toLowerCase().contains(widget.searchQuery.toLowerCase())){
                                  return GestureDetector(
                                    onTap: (){editReminder(context, rem, colorsList[monthIndex%colorsList.length]);},
                                    child: ReminderTile(
                                      title: rem.name,
                                      description: rem.msg,
                                      date: rem.date,
                                      time: rem.time,
                                      isChecked: rem.isDone,
                                      checkBoxCallBack: (checkBoxState) {
                                        reminderDB.updateReminder(rem);
                                      },
                                      deleteCallBack: (context) {
                                                              
                                        reminderDB.deleteReminder(rem, index, rem.id);
                                      },
                                      messageFunc: (context){
                                        reminderDB.launchMessage(rem.number, rem.msg);
                                      },
                                      shareFunc: (context){
                                        reminderDB.launchShare(rem.msg);
                                      },
                                      color: colorsList[monthIndex%colorsList.length]
                                    
                                    ),
                                  );
                                }
                                else{
                                  return Container();
                                }
            
                              } ,
                            )
                          ],
                        );
                        
                      },
                      
                    );
                  
                },
              ),
            ),
          )
          
        ] 
      ),
    );
  }
}
