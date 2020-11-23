import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Web extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new WebviewScaffold(
      url: "https://gocollabo.typeform.com/to/u4L7Sl",

      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'New Project',
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

class MyAppHomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppHomePage> {
  void _opennewpage() {
    Navigator.of(context).pushNamed('/widget');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        width: 170.0,
        height: 60.0,
        padding: const EdgeInsets.only(top: 16.0),
        child: new RaisedButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(32.0),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.add,
                color: Color(0xffffffff),
              ),
              Text(
                ' Add New Project',
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                    fontStyle: FontStyle.normal,
                    fontSize: 13.0),
              )
            ],
          ),
          onPressed: () {
            //go to web view page
            _opennewpage();
          },
          color: const Color(0xFF0277BD),
        ),
      ),
    );
  }
}
