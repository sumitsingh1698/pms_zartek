import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyPDFView extends StatefulWidget {
  final String url;
  MyPDFView(this.url);
  @override
  _MyPDFViewState createState() => _MyPDFViewState();
}

class _MyPDFViewState extends State<MyPDFView> {
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "PDF View",
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
        ),
        body: Container(
            child: Center(
                child: Container(
          child: PDF(
              password: passwordController.text,
              onPageError: (a, _) {
                print("Error In Page");
              },
              onError: (error) {
                String sr = error.toString();

                log(sr);
                if (sr.contains("Password required")) {
                  log("here");
                  showDialog(context: context, builder: (_) => dialog());
                }
              }).fromUrl(
            widget.url,
          ),
        ))));
  }

  Widget dialog() {
    return Dialog(
      child: SingleChildScrollView(
        // color: Colors.red,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              AppBar(
                backgroundColor: const Color(0xff1e88c6),
                automaticallyImplyLeading: false,
                title: Center(
                  child: Text(
                    "Password Protected",
                    style: const TextStyle(
                        // color: const Color(0xff1e88c6),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 17.0),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Text(
                "This PDF is Password Protected. Please provide correct Password below.\n\n If, You don't know Password.\nPlease mail to info@zartek.in to get the password",
                style: const TextStyle(
                    // color: const Color(0xff1e88c6),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0),
              ),
              TextField(
                decoration: InputDecoration(hintText: "Enter Password"),
                controller: passwordController,
              ),
              SizedBox(
                height: 20,
              ),

              // Text("Required Password or Incorrect Password"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    color: const Color(0xff1e88c6),
                    onPressed: () {
                      print(passwordController.text);
                      if (passwordController.text.length == 0) {
                        Fluttertoast.showToast(
                            msg: "Please Enter Valid Password");
                      } else {
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    child: Text(
                      "Submit",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
