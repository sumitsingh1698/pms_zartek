import 'package:flutter/material.dart';
import 'package:zartek_pms/widgets/cardview.dart';


class Feedbackk extends StatefulWidget {
  @override
  _Feedback createState() => new _Feedback();
}

class _Feedback extends State<Feedbackk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('FEEDBACK',
            style: const TextStyle(
                color: const Color(0xff1e88c6),
                fontWeight: FontWeight.w600,
                fontFamily: "Roboto",
                fontStyle: FontStyle.normal,
                fontSize: 20.0)),
      ),
      body: CardV(page: ProjectPages.feedback),
    );
  }
}
