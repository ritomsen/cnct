import 'dart:collection';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
// import 'check_if_user_logged_in.dart';
import 'reminder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cnct/utilities/notification_manager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:cnct/db/db_helper.dart';
import 'package:cnct/db/contacts_db.dart';
import 'package:sqflite/sqflite.dart';


class ReminderDB extends ChangeNotifier {
  // Contains Inds
  List<String> contactsImported = [];
  List<int> _todaysList = []; 
  // Contains Inds of birthdays for each month
  List<List<int>> _monthLists = [for (int i = 0; i<12; i++) [] ];

  // List<Reminder> _reminderList = [for (int i = 1; i<=144; i++)  Reminder(
  //         name: 'Ritom$i',
  //         msg: 'HBD',
  //         date: i%12<9 ? '2024-0${(i%12) +1}-25' : '2024-${(i%12)+1}-25',
  //         time: '0${r.nextInt(10)}:01',
  //         number: '7348646254',
  //         id: i
  //   )];
  // Contains All Reminders
  List<Reminder> _reminderList = [];

  //Contains indicies for birhtdays within next 2 weeks
  List<int> _upcomingList = [];


  ReminderDB(){
    _initializeData();
  }
  UnmodifiableListView<Reminder> get reminderList {
    return UnmodifiableListView(_reminderList);
  }
  UnmodifiableListView<int> get todaysList {
    return UnmodifiableListView(_todaysList);
  }
  UnmodifiableListView<List<int>> get monthLists {
    return UnmodifiableListView(_monthLists);
  }
  UnmodifiableListView<int> get upcomingList {
    return UnmodifiableListView(_upcomingList);
  }

  //Initialize data with db data when opening app
  void _initializeData() async {
    // Load data from the database
    DBHelper dbHelper = DBHelper.instance; 
    _reminderList = await dbHelper.getAllReminders();

    //Load Contact List Data
    ContactsDB contactsDB = ContactsDB.instance; 
    contactsImported = await contactsDB.getAll();

    // Sort the reminder list and update other related lists
    sortReminderList();
    updateTodaysList();
    getUpcomingList();
    getRemindersPerMonth();

    // Notify listeners that the data has been loaded
    notifyListeners();
  }

  //Get the list of birthdays that are today
  void updateTodaysList(){
    _todaysList = [];
    
    final dateFormatter = DateFormat('MM-dd');
    final DateTime currentDate = DateTime.now();
    final now = dateFormatter.format(currentDate);
    // FOR TESTING
    // final now = '2025-03-20'; 
    for (int i = 0; i< _reminderList.length ; i++){
      if (_reminderList[i].date.substring(5)==now){
        _todaysList.add(i);
      }
      else if (_reminderList[i].date.substring(5).compareTo(now)>0){
        break;
      }
      
      
    }
  }

  //Sorts the birthday list
  void sortReminderList(){
    _reminderList.sort((Reminder a,Reminder b) { 
      // DateTime dateTimeA = DateTime.parse('${a.date} ${a.time}:00');
      // DateTime dateTimeB = DateTime.parse('${b.date} ${b.time}:00');
      String aDate = a.date.substring(5);
      String bDate = b.date.substring(5);
      if (aDate.compareTo(bDate) <0){
        return -1;
      }
      else if(aDate.compareTo(bDate) >0){

          return 1;
      }
      else{
        return a.time.compareTo(b.time);
      }
    });
  }
  // Makes a list of list where each list contains the indicies for birthdays in that mmonth
  void getRemindersPerMonth(){
    
    _monthLists = [for (int i = 0; i<12; i++) [] ];
    for (int i = 0; i<_reminderList.length; i++){
      int mon = int.parse(_reminderList[i].date.split('-')[1]) -1;
      _monthLists[mon].add(i);
    }
  }
  
  //adds a Birthday and creates notif
  void addReminder(
    String name,
    String msg,
    String date,
    String time,
    String? number,
    int id
  ) async {
    final reminder = Reminder(
      name: name,
      msg: msg,
      date: date,
      time: time,
      number: number,
      id: id
    );

    //Add reminder to reminder local db
    _reminderList.add(reminder);
    sortReminderList();

    //Add to SQLlite DB
    DBHelper dbHelper = DBHelper.instance; 
    await dbHelper.insertReminder(reminder);

 
    DateTime tod = DateTime.now();
    final dateFormatter = DateFormat('MM-dd');
    String todaysDate = dateFormatter.format(tod);
    if (date.substring(5) == todaysDate){
      updateTodaysList();
    }
    if(int.parse(date.split('-')[1]) == tod.month){
      getUpcomingList();
    }
    notifyListeners();
  }

  // toggle isDone or not
  void updateReminder(Reminder reminder) {
    reminder.toggleDone();
    notifyListeners();
  }

  //Delete a birthday from everything
  void deleteReminder(Reminder reminder, int index, int id) {
    var notificationManager = NotificationManager();
    _reminderList.remove(reminder);
    _todaysList.remove(index);
    _upcomingList.remove(index);
    // Dont need to delete from months list since it will rebuild and call getMonthLists
    notificationManager.removeReminder(id);
    // _firestore.collection('reminders').document('wgbhYkrUEKDMnsvYTiHZ')

    //Delete from DB
    DBHelper dbHelper = DBHelper.instance; 
    dbHelper.deleteRem(reminder.id);
    
    if (reminder.isContact == true){
      ContactsDB contactsDB = ContactsDB.instance;
      contactsDB.delete(reminder.contactID);
    }

    notifyListeners();
  }

  // Launches to message app
  void launchMessage(String? phoneNumber, String message) async {
  // Construct the message URL
    final uri = Uri.parse('sms:$phoneNumber&body=${Uri.encodeFull(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    } 
  }
  // Launches share capabilities
  void launchShare(String message){
    Share.share(message);
  }

  // Updates the year of yesterday's birthday to next year
  void checkYesterdayBirthdayandUpdate(){
    DateTime tod = DateTime.now();
    DateTime yesterday = tod.subtract(const Duration(days:1));
    final dateFormatter = DateFormat('MM-dd');
    String yest = dateFormatter.format(yesterday);

    String nextYear = "${tod.year+1}";

    for (int i = 0; i<_reminderList.length; i++){
      if (_reminderList[i].date.substring(5) == yest && int.parse(_reminderList[i].date.substring(0,4)) == yesterday.year){
        _reminderList[i].date = "$nextYear${_reminderList[i].date.substring(4)}";
      }
      else if(_reminderList[i].date.substring(5).compareTo(yest)>0){
        break;
      }
      // CAN END FOR LOOP BECAUSE IT IS SORTED
    }

    // notifyListeners();

  }

  // Get list of indicies of birthdays within next 2 weeks
  void getUpcomingList(){

    _upcomingList = [];
    final today = DateTime.now();
    final later = today.add(const Duration(days:15));
    DateFormat dateformatter = DateFormat('MM-dd');
    String todaysDate = dateformatter.format(today);
    String laterDate = dateformatter.format(later);

    for(int i = 0; i<_reminderList.length; i++){
      if (_reminderList[i].date.substring(5).compareTo(todaysDate)>0 && _reminderList[i].date.substring(5).compareTo(laterDate)<0){
        _upcomingList.add(i);
      }
      else if(_reminderList[i].date.substring(5).compareTo(laterDate)>0){
        break;
      }
    }

  }

  //Edit Time
  void setTime(Reminder rem, TimeOfDay tim)async {
    String min = "${tim.minute}";
    String hr = "${tim.hour}";
    if (tim.hour <10){
      hr = "0$hr";
    }
    if (tim.minute < 10){
      min = "0$min";
    }
    rem.time = "$hr:$min";

    //Delete and create new reminder
    resetReminder(rem);

    // Edit in DB
    DBHelper dbHelper = DBHelper.instance; 
    await dbHelper.updateRem(rem);

    notifyListeners();
  }

  //Edit Date
  void setDate(Reminder rem, DateTime newDate) async{
    rem.date = newDate.toString().substring(0,10);

    //Delete and create new reminder
    resetReminder(rem);
    DBHelper dbHelper = DBHelper.instance; 
    await dbHelper.updateRem(rem);
    notifyListeners();
  }

  //Edit name
  void setName(Reminder rem, String newName)async {
    rem.name = newName;
    resetReminder(rem);
    DBHelper dbHelper = DBHelper.instance; 
    await dbHelper.updateRem(rem);

    notifyListeners();
  }
  //Edit MSG
  void setMsg(Reminder rem, String newMsg)async {
    rem.msg = newMsg;
    resetReminder(rem);
    DBHelper dbHelper = DBHelper.instance; 
    await dbHelper.updateRem(rem);
    notifyListeners();
  }
  
  //Edit Number
  void setNumber(Reminder rem, String newNumber)async {
    rem.number = newNumber;
    DBHelper dbHelper = DBHelper.instance; 
    await dbHelper.updateRem(rem);

    notifyListeners();
  }

  // Helper Function to help reset notifications
  // Deletes Notification then schedules a new one by calling createnotif
  void resetReminder(Reminder rem){
    var notificationManager = NotificationManager();
    //Delete Reminder
    notificationManager.removeReminder(rem.id);

    //Get DateTime info into ints
    List<String> splitDate = rem.date.split('-');
    int year = int.parse(splitDate[0]);
    int month =int.parse(splitDate[1]);
    int day =int.parse(splitDate[2]);
    List<String> splitTime = rem.time.split(':');
    int hr = int.parse(splitTime[0]);
    int min = int.parse(splitTime[1]);
    //Create TZ instance
    final detroit = tz.getLocation('America/Detroit');
    tz.TZDateTime scheduledNotificationDateTime = tz.TZDateTime(detroit, year, month, day, hr, min);

    //Schedule Notif
    notificationManager.createNotif(rem.id, rem.name, rem.msg, scheduledNotificationDateTime);

  }
  // Imports all birthdays possible from contacts
  Future<void> importAllContacts() async{
    List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
    List<Reminder> remindersToAdd = [];
    List<String> contactsToAdd = [];
    DateTime now = DateTime.now();
    String tempID = "${now.month}${now.day}${now.hour}${now.minute}${now.second}";
    int id = int.parse(tempID);
    for (int i = 0; i<contacts.length; i++){
      if ((!contactsImported.contains(contacts[i].id)) && contacts[i].events.isNotEmpty){
        remindersToAdd.add(await parseContactAndAdd(contacts[i], id));
        contactsToAdd.add(contacts[i].id);
        id++;
      }
    }

    sortReminderList();
    // updateTodaysList();
    // getUpcomingList();
    // getRemindersPerMonth();
    DBHelper dbHelper = DBHelper.instance;
    Database database = await dbHelper.database;
    var batch = database.batch();
  
    for (Reminder reminder in remindersToAdd) {
      batch.insert('reminders', reminder.toMap());
    }
    await batch.commit(noResult: true);

    ContactsDB contactsDB = ContactsDB.instance;
    Database database2 = await contactsDB.database;
    var batch2 = database2.batch();
  
    for (String id in contactsToAdd) {
      batch2.insert('contacts', {'id': id});
    }
    await batch2.commit(noResult: true);
    
  }

  // Parse Contacts info and add into local and sql DBs
  Future<Reminder> parseContactAndAdd(Contact contact, int tempID) async {
        contactsImported.add(contact.id);
        //Get Bday
        String day = "${contact.events[0].day}";
        String month = "${contact.events[0].month}";
        if (int.parse(day) < 10){
          day = "0$day";
        }
        if (int.parse(month)<10){
          month = "0$month";
        }
        String birthday = "$month-$day";
        DateTime now = DateTime.now();
        DateTime temp = DateTime(now.year, int.parse(month), int.parse(day), 23, 59, 59);

        if (temp.compareTo(now)>=0){
          birthday = "${now.year}-$birthday";
        }
        else{
          birthday = "${now.year+1}-$birthday";
        }
        
        //Get Number
        Phone phoneNum = contact.phones[0];
        String parsedNumber = "";
        for(int i = 0; i<phoneNum.number.length; i++){
          if (phoneNum.number[i].codeUnitAt(0) >='0'.codeUnitAt(0) && phoneNum.number[i].codeUnitAt(0) <= '9'.codeUnitAt(0)){
            parsedNumber += phoneNum.number[i];
          }
        }
        //Get Name
        String name = contact.displayName;
        //Set Time to 00:01
        String time = "00:01";

        //Create ID
        int id = tempID;

        Reminder r = Reminder(id:id , name: name, msg: "Happy Birthday!", date: birthday, time: time, number: parsedNumber, isContact: true, contactID: contact.id);
        // Add to ReminderList
        _reminderList.add(r);

        // Create Notification
        var notificationManager = NotificationManager();
        tz.initializeTimeZones();
        final detroit = tz.getLocation('America/Detroit');
        tz.TZDateTime scheduledNotificationDateTime = tz.TZDateTime(detroit, int.parse(birthday.substring(0,4)), int.parse(month), 
        int.parse(day), 0, 1);

        //Schedule Notif
        notificationManager.createNotif(id, name, "Happy Birthday!", scheduledNotificationDateTime);
        return r;
  }
  
}

//helper to format date into readable form
String formatDate(String d) {
  List<String> newD = d.split('-');
  
  return '${newD[1]}/${newD[2]}/${newD[0]}';
}

//Helper to format time to readable form
String formatTime(String t){
  List<String> newT = t.split(':');
  int newHour = int.parse(newT[0]) % 12;
  if (newHour == 0){
    newHour = 12;
  }
  String ending = int.parse(newT[0]) >=12 ? "PM" : "AM";
  return '$newHour:${newT[1]} $ending';
}
