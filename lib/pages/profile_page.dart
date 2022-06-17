import 'package:flutter/material.dart';
import 'package:reseau_social/model/Member.dart';

class ProfilePage extends StatefulWidget {
  Member? member;
  ProfilePage({required this.member});
  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Profile Page"),
    );
  }
}
