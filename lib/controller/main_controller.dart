import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reseau_social/controller/loading_controller.dart';
import 'package:reseau_social/custom_widget/bar_item.dart';
import 'package:reseau_social/pages/home_page.dart';
import 'package:reseau_social/pages/members_page.dart';
import 'package:reseau_social/pages/notif_page.dart';
import 'package:reseau_social/pages/profile_page.dart';
import 'package:reseau_social/pages/write_post.dart';
import 'package:reseau_social/util/constants.dart';
import 'package:reseau_social/util/firebase_handler.dart';
import 'package:reseau_social/model/Member.dart';

class MainController extends StatefulWidget {
  String memberUid;
  MainController({required this.memberUid});
  @override
  State<StatefulWidget> createState() => MainState();
}

class MainState extends State<MainController> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  late StreamSubscription streamSubscription;
  Member? member;
  int index = 0;

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
        member = Member(event);
      });
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("${member?.surname}");
    return (member == null)
        ? LoadingController()
        : Scaffold(
            key: _globalKey,
            appBar: AppBar(
              title: Text("salut"),
            ),
            body: showPage(),
            bottomNavigationBar: BottomAppBar(
              color: Colors.redAccent,
              shape: CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  BarItem(
                      icon: homeIcon,
                      onPressed: (() => buttonSelected(0)),
                      selected: (index == 0)),
                  BarItem(
                      icon: friendsIcon,
                      onPressed: (() => buttonSelected(1)),
                      selected: (index == 1)),
                  Container(
                    width: 0,
                    height: 0,
                  ),
                  BarItem(
                      icon: notifIcon,
                      onPressed: (() => buttonSelected(2)),
                      selected: (index == 2)),
                  BarItem(
                      icon: profileIcon,
                      onPressed: (() => buttonSelected(3)),
                      selected: (index == 3)),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _globalKey.currentState!.showBottomSheet((context) => WritePost(
                      memberId: widget.memberUid,
                    ));
              },
              child: writePost,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
  }

  buttonSelected(int index) {
    setState(() {
      this.index = index;
    });
  }

  Widget? showPage() {
    switch (index) {
      case 0:
        return HomePage(
          member: member,
        );
      case 1:
        return MembersPage(
          member: member,
        );
      case 2:
        return NotifPage(
          member: member,
        );
      case 3:
        return ProfilePage(
          member: member,
        );
    }
  }
}
