import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zartek_pms/screens/details_screen.dart';
import 'package:zartek_pms/screens/help_and_support.dart';
import 'package:zartek_pms/screens/status.dart';

class Myorders extends StatefulWidget {
  String emailid;
  String projectid;
  String projectname;
  String number;
  String files;

  Myorders(
      {Key key,
      @required this.projectid,
      this.emailid,
      this.projectname,
      this.number,
      this.files})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyordersState(projectid, emailid, projectname, number);
  }
}

class MyordersState extends State<Myorders>
    with SingleTickerProviderStateMixin {
  String projectid;
  String PaymentStatus;
  String emailid;
  String projectname;
  String number;
  TabController controller;
  MyordersState(this.projectid, this.emailid, this.projectname, this.number);

  @override
  void initState() {
    super.initState();
    print(widget.files);
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.projectname,
          style: const TextStyle(
              color: Color(0xff1e88c6),
              fontWeight: FontWeight.w400,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
              fontSize: 20.0),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff1e88c6),
          ),
          onPressed: () => Navigator.pop(context, false),
        ),

        backgroundColor: Colors.white,
        elevation: 0.0,
        bottom: TabBar(
            controller: controller,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Text(
                  "STATUS",
                  style: TextStyle(fontSize: 15, color: Color(0xff1e88c6)),
                ),
              ),
              Tab(
                child: Text(
                  "DETAILS",
                  style: TextStyle(fontSize: 15, color: Color(0xff1e88c6)),
                ),
              ),
            ]),

//
//
      ),
      floatingActionButton: Container(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Help(
                          mail: number,
                        )),
              );
            },
            child: Column(
              children: <Widget>[
                CircleAvatar(
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(
                      Icons.chat,
                      color: Color(0xff1e88c6),
                    )),
                // Container(
                //
                Row(
                  children: <Widget>[
                    Text('Raise your concerns',
                        style: const TextStyle(
                            color: const Color(0xff1e88c6),
                            fontWeight: FontWeight.w600,
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
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          MyHome(
            userId: emailid,
            projectid: projectid,
            projectName: projectname,
          ),
          Details(files: jsonDecode(widget.files)),
        ],
      ),
    );
  }
}
