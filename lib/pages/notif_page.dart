import 'package:flutter/material.dart';
import 'package:reseau_social/model/Member.dart';

class NotifPage extends StatefulWidget {
  Member? member;
  NotifPage({required this.member});
  @override
  State<StatefulWidget> createState() => NotifState();
}

class NotifState extends State<NotifPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Notif Page"),
    );
  }
}
