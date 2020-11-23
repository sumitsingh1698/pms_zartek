import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zartek_pms/webview/webview.dart';
import 'package:zartek_pms/widgets/cardview.dart';

class Project extends StatefulWidget {
  String email;
  String password;

  Project({Key key, @required this.email, this.password}) : super(key: key);

  @override
  State<StatefulWidget> createState() {


    return Prjt(email, password);
  }
}

class Prjt extends State<Project> {
  String email;
  String password;

  Prjt(email, password);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('YOUR PROJECTS',
            style: const TextStyle(
                color: const Color(0xff1e88c6),
                fontWeight: FontWeight.w600,
                fontFamily: "Roboto",
                fontStyle: FontStyle.normal,
                fontSize: 20.0)),
      ),
      floatingActionButton: Container(
        height: 60.0,
        width: 60.0,
        child: FittedBox(
          child: GestureDetector(
            onTap: () {
              pushNewScreen(
                context,
                screen: Web(),
                withNavBar: false,
              );
            },
            child: Column(
              children: <Widget>[
                Container(
                  height: 45.0,
                  width: 45.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/folder.png'),
                          fit: BoxFit.contain),
                      shape: BoxShape.rectangle),
                ),
                Row(
                  children: <Widget>[
                    Text('Add New Project',
                        style: const TextStyle(
                            color: const Color(0xff1e88c6),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 8.0)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: CardV(
        mail: widget.email.toString(),
        page: ProjectPages.project,
      ),
    );
  }
}
