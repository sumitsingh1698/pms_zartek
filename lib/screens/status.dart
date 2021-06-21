import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:zartek_pms/models/milestone.dart';

import 'package:zartek_pms/screens/attachments.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:zartek_pms/screens/invoice_pdf.dart';
import 'package:zartek_pms/services/apis.dart';

import 'package:date_format/date_format.dart';

class MyHome extends StatefulWidget {
  String projectid, userId;
  String projectName;
  String PaymentStatus;
  MyHome({this.projectid, this.userId, this.projectName, this.PaymentStatus});

  @override
  MyHomeState createState() => new MyHomeState();
}

int progress = 0;

class MyHomeState extends State<MyHome> {
  String projectName;
  String urlpdfPath;
  String projectid;
  @override
  void initState() {
    super.initState();
  }

  List<Milestone> milestone = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder<List<Milestone>>(
          future: Apis().milestone(),
          builder: (context, snapshot) {
            print('snapshot data' + snapshot.data.toString());
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color(0xff1e88c6))));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return TimelineTile(
                      afterLineStyle:
                          LineStyle(color: Color(0xff1e88c6), thickness: 0.4),
                      beforeLineStyle:
                          LineStyle(thickness: 0.4, color: Color(0xff1e88c6)),
                      alignment: TimelineAlign.start,
                      axis: TimelineAxis.vertical,
                      lineXY: 0,
                      isFirst: index == 0,
                      isLast: index == snapshot.data.length - 1,
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        height: 20,
                        color: Color(0xff1e88c6),
                        indicator: _IndicatorExample(
                            number: '${index + 1}',
                            isCompleted: snapshot.data[index].completed),
                        drawGap: true,
                      ),
                      endChild: SingleChildScrollView(
                        child: ExpandablePanel(
                            tapBodyToCollapse: true,
                            tapHeaderToExpand: true,
                            hasIcon: true,
                            iconColor: Color(0xff1e88c6),
                            header: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(snapshot.data[index].name,
                                      style: const TextStyle(
                                          color: Color(0xff1e88c6),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Calibri",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0)),
                                  Container(
                                    decoration: BoxDecoration(
                                      //                    <-- BoxDecoration
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            expanded: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          'Start Date : ',
                                          // document.data['start_date'],
                                          style: const TextStyle(
                                              color: const Color(0xff1e88c6),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Calibri",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          'End Date  : ',
                                          // document.data['end_date'],
                                          style: const TextStyle(
                                              color: const Color(0xff1e88c6),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Calibri",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(top: 10.0),
                                      //   child: Text(
                                      //     'Payment Status :',
                                      //     // document.data['payment_status'],
                                      //     style: const TextStyle(
                                      //         color: const Color(0xff1e88c6),
                                      //         fontWeight: FontWeight.w400,
                                      //         fontFamily: "Calibri",
                                      //         fontStyle: FontStyle.normal,
                                      //         fontSize: 15.0),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 14.0),
                                        child: snapshot.data[index]
                                                    .startedAtOverride ==
                                                null
                                            ? Text("")
                                            : Text(
                                                formatDate(
                                                    DateTime.parse(snapshot
                                                        .data[index]
                                                        .startedAtOverride),
                                                    [dd, ' ', M, ' ', yyyy]),
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff1e88c6),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Calibri",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15.0),
                                              ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: snapshot.data[index]
                                                    .completedAtOverride ==
                                                null
                                            ? Text("")
                                            : Text(
                                                formatDate(
                                                    DateTime.parse(snapshot
                                                        .data[index]
                                                        .completedAtOverride),
                                                    [dd, ' ', M, ' ', yyyy]),
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff1e88c6),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Calibri",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 15.0),
                                              ),
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {},
                                      //   child: Padding(
                                      //       padding: const EdgeInsets.only(top: 8.0),
                                      //       child: Row(
                                      //         children: <Widget>[
                                      //           SizedBox(width: 5),
                                      //           widget.PaymentStatus ==
                                      //                   "paid"
                                      //               ? Text(
                                      //                 widget.PaymentStatus,
                                      //                   style: const TextStyle(
                                      //                       color: Colors.green,
                                      //                       fontWeight:
                                      //                           FontWeight.w400,
                                      //                       fontFamily: "Calibri",
                                      //                       fontStyle:
                                      //                           FontStyle.normal,
                                      //                       fontSize: 15.0),
                                      //                 )
                                      //               : Text(
                                      //                  widget.PaymentStatus,
                                      //                   style: const TextStyle(
                                      //                       color: Colors.red,
                                      //                       fontWeight:
                                      //                           FontWeight.w400,
                                      //                       fontFamily: "Calibri",
                                      //                       fontStyle:
                                      //                           FontStyle.normal,
                                      //                       fontSize: 15.0),
                                      //                 ),
                                      //         ],
                                      //       )),
                                      // ),
                                    ],
                                  ),
                                ])),
                      ));
                },
              ),
            );
          }),
    );
  }
}

class _IndicatorExample extends StatelessWidget {
  const _IndicatorExample({Key key, this.number, this.isCompleted = false})
      : super(key: key);

  final String number;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        /// color in that
        color: this.isCompleted ? Colors.green : Colors.yellow,

        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(
              // color: Color(0xff1e88c6),
              color: this.isCompleted ? Colors.green : Colors.yellow),
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
