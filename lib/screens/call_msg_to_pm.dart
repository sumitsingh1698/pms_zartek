import 'package:flutter/material.dart';




class Pm extends StatefulWidget {
  @override
  _PmState createState() => _PmState();
}

class _PmState extends State<Pm> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(  0xFFE3F2FD),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Call / Message to PM',  style: const TextStyle(
              color: Color(0xff1e88c6),
              fontWeight: FontWeight.w400,

              fontSize: 18.0)),
        ],
      ),
    );
  }
}
