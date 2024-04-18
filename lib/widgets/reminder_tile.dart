import 'package:cnct/models/reminder_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class ReminderTile extends StatefulWidget {

  final String title; //name
  final String description; //msg
  final String date; //date
  final String time; //time
  final bool isChecked; //is it checked or not
  final dynamic Function(bool?)? checkBoxCallBack; //function when its checked
  final Function(BuildContext)? deleteCallBack; //delete function
  final dynamic Function(BuildContext)? messageFunc; //function that sends it to messages
  final dynamic Function(BuildContext)? shareFunc; //function that sends it to share 
  final Color color; //Color of tile

  const ReminderTile({
    required this.title,
    required this.description,
    this.date = "",
    this.time = "",
    this.isChecked = false,
    required this.checkBoxCallBack,
    required this.deleteCallBack,
    required this.messageFunc,
    required this.shareFunc,
    required this.color
  });

  @override
  State<ReminderTile> createState() => _ReminderTileState();
}

class _ReminderTileState extends State<ReminderTile> {



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
      padding: EdgeInsets.only(top: 10.0.h),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100.0.h,
            // padding: EdgeInsets.only(
            //   top: 20.0.h,
            //   left: 20.0.w,
            // ),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.all(Radius.circular(18.0.w)),
            ),
            
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(18.0.w)),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.75,
                children: [
                  //Delete
                  SlidableAction(
                    backgroundColor: const Color.fromARGB(255, 189, 10, 10),
                    icon: Icons.delete,
                    onPressed: widget.deleteCallBack,
                  ), 
                  //Message
                  SlidableAction(
                    backgroundColor: const Color.fromARGB(215, 7, 205, 17),
                    icon: Icons.message,
                    onPressed: widget.messageFunc,
                  ),
                  //Share
                  SlidableAction(
                    backgroundColor: const Color.fromARGB(214, 210, 224, 14),
                    icon: Icons.share,
                    onPressed: widget.shareFunc,
                  )
                ]),
              child: Container(
                width: (MediaQuery.of(context).size.width),
                height: 100.h,
                padding: EdgeInsets.only(
                  top: 20.0.h,
                  left: 20.0.w,
                ),
                decoration: BoxDecoration(
                  color: widget.isChecked ? widget.color :const Color(0xfffafafa) ,
                  border: Border.all(color: const Color.fromARGB(255, 238, 238, 238), width: 2.0.w),
                  borderRadius: BorderRadius.all(Radius.circular(20.0.w)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Name
                        Expanded(
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              decoration: widget.isChecked
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        Container(
                          width: 20.0.w,
                          height: 5.0.h,
                          decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0.h),
                                  bottomLeft: Radius.circular(10.0.h))),
                        )
                      ],
                    ),
                    //MSG
                    Expanded(
                      child: Text(
                        widget.description,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          fontFamily: 'WorkSans',
                          color: Colors.grey[450],
                          decoration: widget.isChecked
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                    ),
                    // SizedBox(height:3.h),
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.alarm,
                                  // color: Colors.grey[350],
                                  color: widget.isChecked ? Colors.black : widget.color,
                                  size: 11.0.h,
                                ),
                                //Date and Time
                                Text(
                                  ' ${formatDate(widget.date)}, ${formatTime(widget.time)}',
                                  style: TextStyle(
                                    fontSize: 11.0.sp,
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.w600,
                                    // color: Colors.grey[350],
                                    color: widget.isChecked ? Colors.black : widget.color,
                                    decoration: widget.isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                                  ),
                                ),
                              ],
                            ),
                            Transform.scale(
                              scale: 0.7,
                              child: RoundCheckBox(
                                isChecked: widget.isChecked,
                                uncheckedColor: Colors.grey[350],
                                checkedColor: Colors.black,
                                disabledColor: Colors.grey,
                                size: 48,
                                onTap: widget.checkBoxCallBack,
                              ),
                            ),
                          ],
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


