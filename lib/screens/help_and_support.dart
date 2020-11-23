
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/apis.dart';

class Help extends StatefulWidget {
  String mail;
  String project=""
;  Help({this.mail,this.project});
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  String project= "";
  String msga="I want to add a new feature";
  String msgb= "There is a bug in the app";
  String msgc=  "I want to modify the ui design";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Help And Support',
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: Color(0xff1e88c6),
                fontWeight: FontWeight.w500,
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
        ),
        body: Stack(children: <Widget>[
          Container(
            color: Color(0xFFE3F2FD),
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                  child:  Column(
                    children: <Widget>[
                      Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  msga,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1e88c6),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color(0xff1e88c6),
                                  size: 25.0,
                                ),
                                onPressed: ()  {


                                  FlutterOpenWhatsapp.sendSingleMessage(widget.mail , msga);

                                }

                                ),
                          ],
                        ),
                      Container(
                        decoration: BoxDecoration(
                          //                    <-- BoxDecoration
                          border: Border(
                              bottom: BorderSide(color: Colors.black12)),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                msgb,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1e88c6),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xff1e88c6),
                                size: 25.0,
                              ),
                              onPressed: ()  {


                                FlutterOpenWhatsapp.sendSingleMessage(widget.mail , msgb);

                              }),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          //                    <-- BoxDecoration
                          border: Border(
                              bottom: BorderSide(color: Colors.black12)),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                msgc,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff1e88c6),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_right,
                                color: Color(0xff1e88c6),
                                size: 25.0,
                              ),
                              onPressed: ()  {


                                FlutterOpenWhatsapp.sendSingleMessage(widget.mail , msgc);

                              }),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          //                    <-- BoxDecoration
                          border: Border(
                              bottom: BorderSide(color: Colors.black12)),
                        ),
                      ),
                    ],
                  ),


                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(
                  'FACING AN ISSUE ? CHAT WITH US',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1e88c6),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }







  void whatsAppOpen() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String Message = "";
    String number = shared.getString("number");
    await FlutterLaunch.launchWathsApp(
        phone: number ,
        message: Message);
  }
}
