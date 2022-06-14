import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reseau_social/controller/loading_controller.dart';
import 'package:reseau_social/util/firebase_handler.dart';
import 'package:reseau_social/model/Member.dart';

class MainController extends StatefulWidget {
  String memberUid;
  MainController({required this.memberUid});
  @override
  State<StatefulWidget> createState() => MainState();
}

class MainState extends State<MainController> {
  late StreamSubscription streamSubscription;
  Member? member;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Récupère user a partir de uid
    streamSubscription = FirebaseHandler()
        .fire_user
        .doc(widget.memberUid)
        .snapshots()
        .listen((event) {
      setState(() {
        print("I got a member");
        member = Member(event);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("${member?.surname}");
    return (member == null)
        ? LoadingController()
        : Scaffold(
            appBar: AppBar(
              title: Text("salut"),
            ),
            body: Center(
              child: Text(
                "Salut je suis ${member?.name}",
              ),
            ),
          );
    ;
  }
}
