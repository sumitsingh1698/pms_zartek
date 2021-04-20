import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zartek_pms/models/project_status.dart';
import 'package:zartek_pms/progressbar/progress_bar.dart';
import 'package:zartek_pms/screens/invoice_pdf.dart';
import 'package:zartek_pms/screens/status.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:zartek_pms/screens/tabbar.dart';
import 'package:zartek_pms/services/apis.dart';

enum ProjectPages { project, invoice, feedback }
//list item

class CardV extends StatefulWidget {
  final ProjectPages page;
  String mail;
  CardV({this.page, this.mail});

  @override
  CardView createState() => CardView();
}

class CardView extends State<CardV> {
  bool load = false;
  @override
  void initState() {
    super.initState();
  }

  // final CurrentStatus currentStatus;
  double i = 0;
  CardView();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      Apis().Projects().then((res) {
        print('refreshed');
      });
    });

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
//            header: WaterDropHeader(),
//            footer: CustomFooter(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: StreamBuilder<List<Results>>(
            stream: Apis().Projects().asStream(),
            builder: (context, snapshot) {
              print('snapshot data' + snapshot.data.toString());
              if (!snapshot.hasData)
                return Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xff1e88c6))));
              return snapshot.data.length == 0
                  ? Center(
                      child: Text('No Projects',
                          style: const TextStyle(
                              color: const Color(0xff1e88c6),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0)),
                    )
                  : Stack(
                      children: <Widget>[
                        ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StatefulBuilder(
                                  builder: (context, setModelState) {
                                int p = snapshot.data[index].completedStatus;
                                i = (p / 100);
                                return Column(
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () async {
                                          if (widget.page ==
                                              ProjectPages.project) {
                                            pushNewScreen(
                                              context,
                                              screen: Myorders(
                                                projectname: snapshot
                                                    .data[index].project,
                                                projectid: snapshot
                                                    .data[index].id
                                                    .toString(),
                                                number: snapshot.data[index]
                                                    .projectmanagerNumber,
                                                files: jsonEncode(snapshot
                                                    .data[index].document),
                                              ),
                                              withNavBar: false,
                                            );
                                          } else if (widget.page ==
                                              ProjectPages.invoice) {
                                            pushNewScreen(
                                              context,
                                              screen: MyHomePage(
                                                projectname: snapshot
                                                    .data[index].project,
                                                projectid: snapshot
                                                    .data[index].id
                                                    .toString(),
                                                number: snapshot.data[index]
                                                    .projectmanagerNumber,
                                              ),
                                              withNavBar: false,
                                            );
                                          } else if (widget.page ==
                                              ProjectPages.feedback) {
                                            _onRefresh();
                                            setState(() {
                                              FlutterLaunch.launchWathsApp(
                                                  phone: snapshot.data[index]
                                                      .projectmanagerNumber,
                                                  message:
                                                      "Hello  I have some feedback regarding my project");
                                            });

                                            // FlutterOpenWhatsapp.sendSingleMessage(project[index].managerNumber , "Hello  I have some feedback regarding my project");
                                          }
                                        },
                                        child: Card(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 10.0),
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0),
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  // width: 340,
                                                  // height: 149,
                                                  constraints:
                                                      BoxConstraints.expand(
                                                          height: 150.0),
                                                  decoration: new BoxDecoration(
                                                    // boxShadow: [
                                                    //   new BoxShadow(
                                                    //     color: Colors.black,
                                                    //     blurRadius: 10.0,
                                                    //     offset: new Offset(
                                                    //         3.0, 3.0),
                                                    //   )
                                                    // ],
                                                    borderRadius:
                                                        new BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              18.0),
                                                      bottomLeft:
                                                          const Radius.circular(
                                                              8.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              18.0),
                                                      bottomRight:
                                                          const Radius.circular(
                                                              8.0),
                                                    ),
                                                    gradient:
                                                        new LinearGradient(
                                                      colors: [
                                                        const Color(0xFFE3F2FD)
                                                      ],
                                                      stops: [0.0],
                                                      // tileMode: TileMode.repeated
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      //prjname

                                                      Text(
                                                          snapshot.data[index]
                                                              .project
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff1e88c6),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 18.0)),


                                                      RichText(
                                                        textAlign:
                                                            TextAlign.start,
                                                        text:
                                                            TextSpan(children: <
                                                                TextSpan>[
                                                          TextSpan(
                                                            text:
                                                                ('Description :'),
                                                            style: const TextStyle(
                                                                color: const Color(
                                                                    0xff1e88c6),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Roboto",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13.0),
                                                          ),
                                                          TextSpan(
                                                            text: snapshot
                                                                .data[index]
                                                                .description,
                                                            style: const TextStyle(
                                                                color: const Color(
                                                                    0xff1e88c6),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Roboto",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 13.0),
                                                          ),
                                                        ]),
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0.0),
                                                            child: Text(
                                                              'Start Date :',
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff1e88c6),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      13.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          //status
                                                          Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .startDate,
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff1e88c6),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      13.0))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0.0),
                                                            child: Text(
                                                              'End Date :',
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff1e88c6),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      13.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          //status
                                                          Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .endDate,
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff1e88c6),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      13.0))
                                                        ],
                                                      ),
                                                      Visibility(
                                                        visible: widget.page ==
                                                                ProjectPages
                                                                    .invoice
                                                            ? false
                                                            : true,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 0.0),
                                                              child: Text(
                                                                'Payment Status :',
                                                                style: const TextStyle(
                                                                    color: const Color(
                                                                        0xff1e88c6),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        "Roboto",
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        13.0),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ),
                                                            //status
                                                            Text(
                                                                snapshot
                                                                    .data[index]
                                                                    .paymentStatus,
                                                                style: const TextStyle(
                                                                    color: const Color(
                                                                        0xff1e88c6),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        "Roboto",
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        13.0))
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Row(children: <Widget>[
                                                        Expanded(
                                                          child: Visibility(
                                                            visible: snapshot
                                                                        .data[
                                                                            index]
                                                                        .dropboxLink ==
                                                                    ""
                                                                ? false
                                                                : true,
                                                            child: Container(
                                                              height: 18.0,
                                                              width: 1.0,
                                                              child: FlatButton(
                                                                color: Color(
                                                                    0xFFE3F2FD),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      'DropBox Link',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Color(
                                                                            0xff1e88c6),
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        decoration:
                                                                            TextDecoration.underline,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onPressed: () {
                                                                  pushNewScreen(
                                                                    context,
                                                                    screen:
                                                                        Webview(
                                                                      url: snapshot
                                                                          .data[
                                                                              index]
                                                                          .dropboxLink,
                                                                    ),
                                                                    withNavBar:
                                                                        false,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        snapshot.data[index]
                                                                    .completedStatus ==
                                                                100
                                                            ? Text(
                                                                snapshot
                                                                        .data[
                                                                            index]
                                                                        .completedStatus
                                                                        .toString() +
                                                                    '% Completed',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .green),
                                                              )
                                                            : Text(
                                                                snapshot
                                                                        .data[
                                                                            index]
                                                                        .completedStatus
                                                                        .toString() +
                                                                    '% Completed',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Color(
                                                                        0xff1e88c6)),
                                                              ),
                                                      ]),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: LinearPercentIndicator(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 7.1),
                                                    animation: true,
                                                    animationDuration: 1000,
                                                    lineHeight: 8.0,
                                                    percent: i,
                                                    linearStrokeCap:
                                                        LinearStrokeCap
                                                            .roundAll,
                                                    progressColor:
                                                        Color(0xff216693),
                                                  ),
                                                )
                                              ],
                                            ))),
                                  ],
                                );
                              });
                            }),
                      ],
                    );
            }));
  }

  void whatsAppOpen() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String number = shared.getString("number");
    String email = widget.mail.toString();
    print(number);
    await FlutterLaunch.launchWathsApp(
        phone: number,
        message: 'Hello  I have some feedback regarding my project');
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
            "Drop BoxLink",
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
