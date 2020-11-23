
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zartek_pms/progressbar/progress_bar.dart';
import 'package:zartek_pms/screens/login.dart';
import 'package:zartek_pms/services/apis.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:zartek_pms/main.dart';

class Profile extends StatefulWidget {
  String email;
  String password;

  Profile({Key key, @required this.email, this.password}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfileState(email, password);
  }
}

class _ProfileState extends State<Profile> {
  _ProfileState(email, password);

  String email;
  String password;

  String clientName = "";
  String clientmail = "";
  bool load = false;


  @override
  void initState() {
    super.initState();

    Apis().profile().then((res) {
      setState(() {
        clientName = res["name"].toString();
        clientmail = res["email"].toString();
        load = true;
        print(clientName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: !load
          ? customProgress()
          : ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 50.0,
                          color: Color(0xff1e88c6),
                        ),
                        Text(
                          clientName ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1e88c6)
                              // fontFamily: 'Times new Roman'
                              ),
                        ),
                        Text(
                          clientmail ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff1e88c6)
                              // fontFamily: 'Times new Roman'
                              ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Contact Us',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff1e88c6)),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Email Us",
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
                                  UrlLauncher.launch("mailto:info@zartek.in");
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
                                  "Call Us",
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
                                  UrlLauncher.launch("tel:(+91) ");
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
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Support',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff1e88c6)),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "About Us",
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
                                  pushNewScreen(
                                    context,
                                    screen:Website(url: "https://zartek.in/about-us",titleName: "About Us",),
                                    withNavBar: false,
                                  );
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
                                  "Our Services",
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
                                  pushNewScreen(
                                    context,
                                    screen:Website(url: "https://zartek.in/services",titleName: "Our Services",),
                                    withNavBar: false,
                                  );

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
                                  "Dedicated Resources",
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

                                  pushNewScreen(
                                    context,
                                    screen:Website(url: "https://zartek.in/hire-dedicated-developer ",titleName: "Dedicated Resources",),
                                    withNavBar: false,
                                  );
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
                                  "Our Blog",
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

                                  pushNewScreen(
                                    context,
                                    screen:Website(url: "https://medium.com/zartek ",titleName: "OurBlog",),
                                    withNavBar: false,
                                  );
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
                                  "Log Out",
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
                                  _signout();
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
            ]),
    );
  }

  void _signout() async {
    final String tok = "token";
    // final String is_user_login_success = "status";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(tok);
    pushNewScreen(
      context,
      screen: Login(),
      withNavBar: false,
    );
  }
}

class Website extends StatefulWidget {
  String titleName="";
  String url;
  Website({this.titleName,this.url});
  @override
  _WebsiteState createState() => _WebsiteState();
}

class _WebsiteState extends State<Website> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new WebviewScaffold(
          url: widget.url,

          appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                widget.titleName,
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
