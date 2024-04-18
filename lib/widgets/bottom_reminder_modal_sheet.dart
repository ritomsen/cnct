
import 'package:cnct/models/reminder_db.dart';
import 'package:cnct/utilities/notification_manager.dart';
// import 'package:checklst/utilities/location_service.dart';
// import 'package:cnct/utilities/routing_constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'reminder_sheet_textfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// import 'package:cnct/utilities/id_creator.dart';
int createID(){
  DateTime t = DateTime.now();
  String tempID = "${t.month}${t.day}${t.hour}${t.minute}${t.second}";
  return int.parse(tempID);

}
class BottomReminderSheet extends StatefulWidget {
  @override
  _BottomReminderSheetState createState() => _BottomReminderSheetState();
}

class _BottomReminderSheetState extends State<BottomReminderSheet> {
  // LocationService locationService = LocationService();
  var notficationManager = NotificationManager();
  final bool _isSwitched = false;
  final nameTextController = TextEditingController();
  final messageTextController = TextEditingController(text: 'Happy Birthday!');
  final phoneNumberController = TextEditingController();

  String phoneNumber = "";
  String date = "01-01-2003";
  String time = "00:01";
  int hours = 0;
  int minutes = 0;
  PermissionStatus contPerm = PermissionStatus.denied;
  // void getUserLocation() async {
  //   userLocation = await locationService.getLocation();
  // }



  // //TODO: implement better logic
  // void getDuration() {
  //   //splitting of time
  //   List reminderTime = time.split(':');

  //   DateTime now = DateTime.now();
  //   List currentTime = DateFormat('kk:mm').format(now).split(':');

  //   hours = int.parse(reminderTime[0]) - int.parse(currentTime[0]);
  //   minutes = int.parse(reminderTime[1]) - int.parse(currentTime[1]) - 1;
  // }

  

  @override
  void initState(){
    super.initState();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));
  }

// ignore: missing_return
  // Future onSelectNotification(String payload) {
  //   // Navigator.of(context).push(
  //   //   MaterialPageRoute(
  //   //     builder: (_) {
  //   //       return IndexView();
  //   //     },
  //   //   ),
  //   // );
  // }

 
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    ScreenUtil.init(context,
        designSize: Size(width, height));

    return Container(
      padding: EdgeInsets.all(30.0.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0.w),
          topRight: Radius.circular(30.0.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Add Birthday',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40.0.sp,
              fontFamily: 'WorkSans',
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0.h),
            child: Column(
              children: [
                ReminderSheetTextField(
                    taskTextController: nameTextController,
                    helperText: 'Name of Person'),
                SizedBox(height: 10.0.h),
                ReminderSheetTextField(
                    taskTextController: messageTextController,
                    helperText: 'B-day Message (~30 chars)',),
                SizedBox(height: 10.0.h),
                Row(
                  children: [
                    Expanded(
                      child: ReminderSheetTextField(
                          taskTextController: phoneNumberController,
                          helperText: 'Phone Number (no dashes)'),
                    ),
                    Container(
                      width: 100.0.w,
                      padding: EdgeInsets.only(bottom: 20.0.h, left: 10.0.w),
                      child: FloatingActionButton(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        onPressed: () async{
                          if (contPerm.isDenied){
                              final status = await Permission.contacts.request();
                              setState(() {
                                contPerm = status;
                              }); 
                          }
                          final contact = await FlutterContacts.openExternalPick();
                                      
                          if (contact!=null){
                            Phone phoneNum = contact.phones[0];
                            // Parse contact string
                            String n = "";
                            for(int i = 0; i<phoneNum.number.length; i++){
                              if (phoneNum.number[i].codeUnitAt(0) >='0'.codeUnitAt(0) && phoneNum.number[i].codeUnitAt(0) <= '9'.codeUnitAt(0)){
                                n += phoneNum.number[i];
                              }
                            }
                            
                            phoneNumberController.text = n;
                            // TESTING
                            // phoneNumberController.text = "${contact.events[0].year}-${contact.events[0].month}-${contact.events[0].day}";
                          }
                        },
                          
                         
                        child: Text("Import",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0.sp,
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.w600,
                        ))),
                    )
                  ],
                ),
                SizedBox(height: 10.0.h),
                Visibility(
                  visible: !_isSwitched,
                  child: Column(
                    children: [
                      DateTimePicker(
                        type: DateTimePickerType.date,
                        dateMask: 'MM/dd/yyyy',
                        // initialValue: '26 Nov,2020',
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: const Icon(Icons.event),
                        dateLabelText: 'Date',
                        autovalidate: true,
                        onChanged: (val) {
                          date = val;
                        },
                        validator: (val) {
                          if (val == null || val == ''){
                            return null;
                          }
                          var now = tz.TZDateTime.now(tz.getLocation('America/Detroit'));
                          var valDate = tz.TZDateTime.parse(tz.getLocation('America/Detroit'),val);
                          if(valDate.year > now.year){
                            return null;
                          }
                          else if(valDate.year == now.year){
                            if(valDate.month > now.month){
                              return null;
                            }
                            else if(valDate.month == now.month){
                              if (valDate.day >=now.day){
                                return null;
                              }

                            }
                          
                          }
                          return "Pick a date today or after today!";
                        },
                      ),
                      DateTimePicker(
                        type: DateTimePickerType.time,
                        icon: const Icon(Icons.access_time),
                        timeLabelText: "Time",
                        use24HourFormat: true,
                        autovalidate: true,
                        onChanged: (val) {
                          time = val;
                        },
                        validator: (val) {
                          // Check if date is after today
                         return null;
                        },
                        onSaved: (val) {
                          if (val != null){
                            time = val;
                          }
                        },
                        initialTime: const TimeOfDay(hour:0, minute:1),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.0.h),
                
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            buttonMinWidth: 150.0.w,
            children: <Widget>[
              ElevatedButton(
                  style:ElevatedButton.styleFrom(
                  elevation: 8.0.h,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0.h),
                  ),
                  padding: EdgeInsets.only(
                      left: 15.w, bottom: 11.h, top: 11.h, right: 15.w)),
                onPressed: () {
                  if (nameTextController.text == '' ||
                      messageTextController.text == '') {
                    //Test case if user clicks add with null title and description
                  } else {

                    List<String> splitDate = date.split('-');
                    int year = int.parse(splitDate[0]);
                    int month =int.parse(splitDate[1]);
                    int day =int.parse(splitDate[2]);
                    List<String> splitTime = time.split(':');
                    int hr = int.parse(splitTime[0]);
                    int min = int.parse(splitTime[1]);
                    final detroit = tz.getLocation('America/Detroit');
                    tz.TZDateTime scheduledNotificationDateTime = tz.TZDateTime(detroit, year, month, day, hr, min);
                    int id = createID();
                    notficationManager.createNotif(id, nameTextController.text, messageTextController.text, scheduledNotificationDateTime);
                    Provider.of<ReminderDB>(context, listen: false)
                      .addReminder(nameTextController.text,
                          messageTextController.text, date, time, phoneNumberController.text, id);

                    nameTextController.clear();
                    messageTextController.clear();
                  }

                    Navigator.pop(context);
                
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 22.0.sp,
                    fontFamily: 'WorkSans',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10.0.w),
              ElevatedButton(
                style:ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  elevation: 8.0.h,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0.h),
                  ),
                  padding: EdgeInsets.only(
                      left: 15.w, bottom: 11.h, top: 11.h, right: 15.w)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 22.0.sp,
                    fontFamily: 'WorkSans',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 100.0.h),
        ],
      ),
    );
  }
}
