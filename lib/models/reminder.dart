
class Reminder {
  int id; //id for notification plugin
  String name; //Name of person
  String msg; // Birthday msg
  String date; //YYYY-MM-DD
  String time; //HH:MM
  String? number; //no dashes, like 99999999999
  bool isDone; //Toggles checking function of reminder
  bool isContact; // If its imported from contacts
  String contactID; //If it is imported this is the contact ID
  void toggleDone() {
    isDone = !isDone;
  }

  Reminder(
      {required this.name,
      required this.msg,
      required this.date,
      required this.time,
      this.number,
      this.isDone = false,
      required this.id,
      this.isContact = false,
      this.contactID = ""}
      );

  //Mapping function to help with sql DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'msg': msg,
      'date': date,
      'time': time,
      'number': number,
      'isContact': (isContact) ? 1: 0,
      'contactID': contactID,
    };
  }

  // Add a factory constructor to create a Reminder object from a map
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      name: map['name'],
      msg: map['msg'],
      date: map['date'],
      time: map['time'],
      number: map['number'],
      isContact: map['isContact'],
      contactID: map['contactID']
    );
  }
}

