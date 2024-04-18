import "package:flutter/material.dart";
import 'package:cnct/models/reminder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cnct/models/reminder_db.dart';
import 'package:provider/provider.dart';
void editReminder(BuildContext context, Reminder reminder, Color col) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:true ,
      builder: (context) {
        
        // Implement your modal to edit the reminder here
        return EditReminderSheet(reminder: reminder, col: col);
      },
    );
  }

class EditReminderSheet extends StatefulWidget {
   final Reminder reminder;
   final Color col;
   const EditReminderSheet({
    super.key,
    required this.reminder,
    required this.col

  });
  @override
  State<EditReminderSheet> createState() => _EditReminderSheetState();
}
class _EditReminderSheetState extends State<EditReminderSheet>{
  bool editName = false;
  final TextEditingController _editNameController = TextEditingController();

  bool editNumber = false;
  final TextEditingController _editNumberController = TextEditingController();

  bool editMsg = false;
  final TextEditingController _editMsgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(432.0, 816.0));
    return Wrap(
      children: [Container(
        // Your modal content goes here
        padding: EdgeInsets.all(20.0.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0.w),
            topRight: Radius.circular(30.0.w),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.0.h),
              child: Text(
                "Details",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Playfair",
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Divider(
              color: Colors.black,
              height: 1.0,
              thickness: 1.0,
            ),
            SizedBox(height: 10.0.h),
            Row(
              children: [
                Expanded(
                  child: Text("Name:", 
                  style: TextStyle( color: Colors.black, fontFamily: "Playfair", fontSize: 22.0.sp, fontWeight: FontWeight.w700)
                  ),
                ),
                
                ElevatedButton(
                  onPressed:() {setState((){editName=true;});},
                  child: const Text('Edit'),
                ),
              ],
            ),
            
            SizedBox(height:3.h),
            Row(
              children: [
                (editName) ?  
                Expanded(
                  child: TextField(
                    controller: _editNameController, 
                    decoration: const InputDecoration(hintText: "Enter New Name"),
                    onSubmitted: (value){
                      setState((){
                        Provider.of<ReminderDB>(context, listen:false).setName(widget.reminder, value);
                        editName = false;
                        _editNameController.clear();});
                    },),
                )
                : Text(widget.reminder.name,
                style: TextStyle(fontFamily: "WorkSans", color: widget.col, fontSize: 20.0.sp, fontWeight: FontWeight.w600)),
              ],
            ),
            SizedBox(height:3.h),
            Row(
              children: [
                Expanded(
                  child: Text("Birthday Message:", 
                  style: TextStyle( color: Colors.black, fontFamily: "Playfair", fontSize: 22.0.sp, fontWeight: FontWeight.w700)
                  ),
                ),
                ElevatedButton(
                  onPressed:(){
                    setState((){editMsg = true;});
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
            SizedBox(height:3.h),
             Row(
              children: [
                (editMsg) ?
                  Expanded(
                  child: TextField(
                    controller: _editMsgController, 
                    decoration: const InputDecoration(hintText: "Enter Birthday Msg"),
                    onSubmitted: (value){
                      setState((){
                        Provider.of<ReminderDB>(context, listen:false).setMsg(widget.reminder, value);
                        editMsg = false;
                        _editMsgController.clear();});
                    },),
                )
                : Expanded(
                  child: Text(widget.reminder.msg,
                  style: TextStyle(fontFamily: "WorkSans", color: widget.col, fontSize: 20.0.sp, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            SizedBox(height:3.h),
            Row(
              children: [
                Expanded(
                  child: Text("Phone Number:", 
                  style: TextStyle( color: Colors.black, fontFamily: "Playfair", fontSize: 22.0.sp, fontWeight: FontWeight.w700)
                  ),
                ),
                ElevatedButton(
                  onPressed:(){
                    setState((){editNumber = true;});
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
            SizedBox(height:3.h),
            Row(
              children: [

                (editNumber)?
                Expanded(
                  child: TextField(
                    controller: _editNumberController, 
                    decoration: const InputDecoration(hintText: "Enter New Name"),
                    onSubmitted: (value){
                      setState((){
                        Provider.of<ReminderDB>(context, listen:false).setNumber(widget.reminder, value);
                        editNumber = false;
                        _editNumberController.clear();});
                    },),
                )
                :(widget.reminder.number !=null && widget.reminder.number!="") ? Text("${widget.reminder.number}", style: TextStyle(fontFamily: "WorkSans", color: widget.col, fontSize: 20.0.sp, fontWeight: FontWeight.w600)) 
                :  Text("N/A", style: TextStyle(fontFamily: "WorkSans", color: widget.col, fontSize: 20.0.sp, fontWeight: FontWeight.w600)),
              ], 
            ),
            SizedBox(height:3.h),
            Row(
              children: [
                Expanded(
                  child: Text("Birthday Date:", 
                  style: TextStyle( color: Colors.black, fontFamily: "Playfair", fontSize: 22.0.sp, fontWeight: FontWeight.w700)
                  ),
                ),
                ElevatedButton(
                  onPressed:() async {
                    DateTime? newDate = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
                    if (newDate != null){
                      setState((){ 
                        Provider.of<ReminderDB>(context, listen:false).setDate(widget.reminder, newDate);
                      });
                    }
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
            SizedBox(height:3.h),
            Row(
              children: [
               Text(formatDate(widget.reminder.date).substring(0,5), 
                style: TextStyle(fontFamily: "WorkSans", color: widget.col, fontSize: 20.0.sp, fontWeight: FontWeight.w600)),
              ],
            ),
            SizedBox(height:3.h),
            Row(
              children: [
                Expanded(
                  child: Text("Reminder Time:", 
                  style: TextStyle( color: Colors.black, fontFamily: "Playfair", fontSize: 22.0.sp, fontWeight: FontWeight.w700)
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed:() async {
                    List<String> time = widget.reminder.time.split(':');
                    TimeOfDay? newTime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1])));
                    if (newTime!=null){
                      setState((){
                        Provider.of<ReminderDB>(context, listen:false).setTime(widget.reminder, newTime);
                      });
                      // Provider.of<ReminderDB>(context, listen:false).setTime(reminder, newTime);
                    }
                  },
                  
                  child: const Text('Edit'),
                ),
              ],
            ),
            SizedBox(height:3.h),
            Row(
              children: [
                Text(formatTime(widget.reminder.time),
                style: TextStyle(fontFamily: "WorkSans", color: widget.col, fontSize: 20.0.sp, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        )
      ),
    ]);
  }
}