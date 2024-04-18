import 'package:cnct/views/body_widgets/all_bdays_body.dart';
import "package:flutter/material.dart";
// import 'package:provider/provider.dart';

class AllBirthdaysViews extends StatefulWidget {
  final String searchQuery;

  AllBirthdaysViews({this.searchQuery = ""});

  @override
  State<AllBirthdaysViews> createState() => _AllBirthdaysState();
}

class _AllBirthdaysState extends State<AllBirthdaysViews> {
  @override
  Widget build(BuildContext context) {
    // return Provider.of<CheckIfUserLoggedIn>(context).getCurrentUser()
    //     ? ProfileBody()
    //     : AuthBody();
    return AllBdayBody(searchQuery: widget.searchQuery);
  }
}

