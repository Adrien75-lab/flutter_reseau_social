import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:reseau_social/custom_widget/my_gradient.dart';
import 'package:reseau_social/custom_widget/my_textField.dart';
import 'package:reseau_social/custom_widget/padding_with.dart';
import 'package:reseau_social/model/alert_helper.dart';
import 'package:reseau_social/model/my_painter.dart';
import 'package:reseau_social/util/firebase_handler.dart';
import 'package:reseau_social/util/main.dart';

class AuthController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AuthState();
}

class AuthState extends State<AuthController> {
  late PageController _pageController;
  late TextEditingController _mail;
  late TextEditingController _password;
  late TextEditingController _name;
  late TextEditingController _surname;
  @override
  void initState() {
    _pageController = PageController();
    _mail = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    _surname = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    _mail.dispose();
    _password.dispose();
    _name.dispose();
    _surname.dispose();

    super.dispose();
  }

  hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow;
        return true;
      },
      child: SingleChildScrollView(
        child: InkWell(
          onTap: () {
            hideKeyboard();
          },
          child: Container(
            decoration:
                MyGradient(startColor: Colors.white, endColor: Colors.red),
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.width > 700)
                ? MediaQuery.of(context).size.height
                : 700,
            child: SafeArea(
              child: Column(
                children: [
                  Image.asset(logoImage,
                      height: MediaQuery.of(context).size.height / 5),
                  logOrCreateButtons(),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: [logCard(true), logCard(false)],
                    ),
                    flex: 5,
                  ),
                  PaddingWith(
                    child: TextButton(
                        onPressed: () {
                          authToFirebase();
                        },
                        child: Container(
                          decoration: MyGradient(
                              startColor: Colors.white, endColor: Colors.red),
                          child: Center(child: Text("C'est Parti ! ")),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget logOrCreateButtons() {
    return Container(
        width: 300,
        height: 50,
        child: CustomPaint(
          painter: MyPainter(pageController: _pageController),
          child: Row(children: [btn("Se connecter"), btn("Créer un compte")]),
        ));
  }

  Expanded btn(String name) {
    return Expanded(
      child: TextButton(
        child: Text(name),
        onPressed: () {
          int page = (_pageController.page == 0.0) ? 1 : 0;
          _pageController.animateToPage(page,
              duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        },
      ),
    );
  }

  Widget logCard(bool userExists) {
    List<Widget> list = [];
    if (!userExists) {
      list.add(MyTextField(
        controller: _surname,
        hint: "Entrez votre prénom",
      ));
      list.add(MyTextField(
        controller: _name,
        hint: "Entrez votre nom",
      ));
    }
    list.add(MyTextField(
      controller: _mail,
      hint: "Entrez votre mail",
    ));
    list.add(MyTextField(
        controller: _password,
        hint: "Entrez votre Mot de passe",
        obscure: true));
    return PaddingWith(
        child: Card(
          elevation: 7.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: list,
          ),
        ),
        bottom: 100);
  }

  authToFirebase() {
    bool signIn = (_pageController.page == 0);
    String name = _name.text;
    String surname = _surname.text;
    String mail = _mail.text;
    String pwd = _password.text;
    if ((validText(mail)) && (validText(pwd))) {
      if (signIn) {
        // Méthode vers firebase
        FirebaseHandler().signIn(mail, pwd);
      } else {
        if ((validText(name)) && (validText(surname))) {
          FirebaseHandler().createUser(mail, pwd, name, surname);
        } else {
          // Alerte nom et prénom
          AlertHelper().error(context, "Nom ou prénom inexistant");
        }
      }
    } else {
      // Alerte utilisateur pas de mail ou de mot de passe
      AlertHelper().error(context, "Mot de passe ou mail inexistant");
    }
  }

  bool validText(String string) {
    return (string != null && string != "");
  }
}
