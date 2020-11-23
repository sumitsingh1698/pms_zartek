
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/milestone.dart';
import '../services/apis.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class Details extends StatefulWidget {

  String projectID;
  Details({this.projectID});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String urlpdfPath;
  String ashik ="";


  @override
  void initState() {
    super.initState();

    var body = {"project_id": widget.projectID};
    print('gggggggggg' + body.toString());

    Apis().milestone(body: body).then((res) {
      print(res);
      setState(() {
        milestone = (res["milestones"] as List)
            .map((item) => Milestone.fromJson(item))
            .toList();
      });
    });
  }

  List<Milestone> milestone = [];
  String projectID;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context,index)=>
            Container(
              decoration: BoxDecoration(
                //                    <-- BoxDecoration
                border: Border(
                    bottom: BorderSide(color: Colors.black12)),
              ),
            ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: milestone.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Technical Document",
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
                  onPressed: () {

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Webview(url: milestone[index].dropboxLink,),
                        ));
                  }),
            ],
          );
        });
  }
}

class Webview extends StatefulWidget {
  String url;
  Webview({this.url});
  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new WebviewScaffold(
          url: widget.url,

          appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
               "Technical Document",
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
              )),
          withZoom: false,
          withLocalStorage: true,
        ));
  }
}

