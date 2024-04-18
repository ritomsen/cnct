// import 'package:checklst/models/check_if_user_logged_in.dart';
import 'package:cnct/widgets/bottom_reminder_modal_sheet.dart';
import 'package:cnct/widgets/fab_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'birthdays_view.dart';
import 'home_page.dart';
import 'package:cnct/models/reminder_db.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
class IndexView extends StatefulWidget {
  @override
  State<IndexView> createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {
  String _searchQuery = "";
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  final TextEditingController _searchController = TextEditingController();
  int _index = 0;

  // int _index = 1;
  


  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [
      RemindersView(),
      AllBirthdaysViews(searchQuery: _searchQuery),
      ];
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    ScreenUtil.init(context,
        designSize: Size(_width, _height));
    Provider.of<ReminderDB>(context, listen:false).checkYesterdayBirthdayandUpdate();  
    
    // return ChangeNotifierProvider<CheckIfUserLoggedIn>(
    //   create: (context) => CheckIfUserLoggedIn(),
    //   child: 
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0.h,
          backgroundColor: const Color.fromARGB(255, 254, 254, 254),
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Text(
            'Cnct.',
            style: TextStyle(
              fontSize: 30.0.sp,
              color: Colors.black,
              fontFamily: 'Playfair',
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            (_index ==1) ?
            Container(
              width: _width - 180.0.w,
              margin: EdgeInsets.only(right: 15.0.w, top: 5.0.h),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                 });
                },
                onSubmitted: (val){
                  setState((){
                    _searchQuery = val;
                    _searchController.clear();
                  });
                },
                // controller: edasdfitingController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: "Search reminder...",
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[350],
                    fontSize: 13.0.sp,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black 
                    ),
                    onPressed: () {
                      setState(() {
                        _searchQuery = _searchController.text;
                        _searchController.clear();
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0.h),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0.h),
                    ),
                  ),
                ),
              ),
            ): Container(),
          ],
        ),
        body: widgetList[_index],
        bottomNavigationBar: FABBottomAppBar(
          centerItemText: 'Add Birthday',
          color: Colors.grey,
          backgroundColor: Colors.white,
          selectedColor: Colors.black,
          notchedShape: const CircularNotchedRectangle(),
          onTabSelected: (index) {
            setState(() {
              _index = index;
            });
          },
          items: [
            FABBottomAppBarItem(iconData: Icons.menu, text: 'Today'),
            FABBottomAppBarItem(iconData: Icons.all_inbox, text: 'All Birthdays'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_permissionStatus.isDenied){
              requestPermission(Permission.notification);
            }
            showModalBottomSheet<dynamic>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Wrap(
                  children: [
                    BottomReminderSheet(),
                  ],
                );
              },
            );
          },
          highlightElevation: 3.0.h,
          
          elevation: 2.0.h,
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        extendBody:
            true, // ensures that that scaffold's body will be visible through the bottom navigation bar's notch
      );
  }
  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      _permissionStatus = status;
    });
  }
  
}


