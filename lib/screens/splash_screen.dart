import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zartek_pms/bottomnavbar/home_widget.dart';
import 'package:zartek_pms/screens/login.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(seconds: 2), () {
      checkUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(gradient: LinearGradient(
              colors: [
                Color(0xFFACC9DB),
                // Color(0xFF78A7C5),
                Color(0xFF256EA1),
              ],
              stops: [0.1,2.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 120.0),
                        ),
                       Container(
                         height: 90.0,
                         width: 155.0,
                         decoration: BoxDecoration(image: DecorationImage(
                         image: AssetImage('images/logo.png'),fit: BoxFit.contain

                       ),
                         shape: BoxShape.rectangle
                       ),)
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void checkUser() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String tok = shared.getString("token");

    if (tok == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
      //signed out
    } else {
      //signed in
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }
}
