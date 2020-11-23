import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zartek_pms/screens/feedback.dart';
import 'package:zartek_pms/screens/invoice.dart';
import 'package:zartek_pms/screens/profile.dart';
import 'package:zartek_pms/screens/project.dart';

//Botttom navigation
class Home extends StatefulWidget {
  String email;
  String password;

  Home({
    Key key,
    @required this.email,
    this.password,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState(email, password);
  }
}

class _HomeState extends State<Home> {
  String email;
  String password;

  _HomeState(email, password);

  int _selectIndex = 0;
  PageController _pageController;
  bool invoice = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      padding: NavBarPadding.all(8),
      screens: <Widget>[
        Project(
          email: widget.email.toString(),
        ),
        Invoice(),
        Feedbackk(),
        Profile(
          email: widget.email.toString(),
          password: widget.password.toString(),
        ),
      ],
      onItemSelected: (index) => setState(() {
        _selectIndex = index;
      }),
      navBarStyle: NavBarStyle.style7,
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.folder),
          title: ('Projects'),
          activeContentColor: Colors.white,
          activeColor: Color(0xff1e88c6),
        ),
        PersistentBottomNavBarItem(
          activeContentColor: CupertinoColors.white,

          icon: _selectIndex == 1
              ? Image.asset(
                  "images/invoice_icon.png",
                )
              : Image.asset(
                  "images/invoice.png",
                ),
          title: ("Payments"),
          activeColor: Color(0xff1e88c6),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.feedback),
          title: ("Feedback"),
          activeContentColor: CupertinoColors.white,
          activeColor: Color(0xff1e88c6),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
          title: ("Profile"),
          activeColor: Color(0xff1e88c6),
          activeContentColor: CupertinoColors.white,
        ),
      ],
    );
  }
}
