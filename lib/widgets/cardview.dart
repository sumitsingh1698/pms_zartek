import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zartek_pms/models/project_status.dart';
import 'package:zartek_pms/screens/invoice_pdf.dart';
import 'package:zartek_pms/screens/tabbar.dart';
import 'package:zartek_pms/services/apis.dart';
import 'package:zartek_pms/utils/whatup_launcher.dart';

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

                                ///----------------------------------------//
                                ///addded by sumit
                                if (widget.page == ProjectPages.invoice) {
                                  return MyHomePage(
                                    projectname: snapshot.data[index].project,
                                    projectid:
                                        snapshot.data[index].id.toString(),
                                    number: snapshot
                                        .data[index].projectmanagerNumber,
                                  );
                                }

                                ///----------------------------------------//

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
                                              //   FlutterLaunch.launchWathsApp(
                                              //       phone: snapshot.data[index]
                                              //           .projectmanagerNumber,
                                              //       message:
                                              //           "Hello  I have some feedback regarding my project");
                                              // });

                                              launch(urlWhatup(
                                                  phone: snapshot.data[index]
                                                      .projectmanagerNumber,
                                                  message:
                                                      "Hello  I have some feedback regarding my project"));
                                            });
                                          }
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 10.0),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
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
                                                                      .w500,
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 25.0)),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text("Description :",
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff1e88c6),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  "Roboto",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 17.0)),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      RichText(
                                                        textAlign:
                                                            TextAlign.start,
                                                        text:
                                                            TextSpan(children: <
                                                                TextSpan>[
                                                          TextSpan(
                                                            text: snapshot
                                                                .data[index]
                                                                .description,
                                                            style: const TextStyle(
                                                                color: const Color(
                                                                    0xff9e9e9e),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Roboto",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 17.0),
                                                          ),
                                                        ]),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0.0),
                                                            child: Text(
                                                              'Start Date : ',
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff9e9e9e),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      17.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          //status
                                                          Text(
                                                              snapshot.data[index].startDate ==
                                                                      null
                                                                  ? ""
                                                                  : formatDate(
                                                                      DateTime.parse(snapshot
                                                                          .data[index]
                                                                          .startDate),
                                                                      [
                                                                          dd,
                                                                          " ",
                                                                          M,
                                                                          " ",
                                                                          yyyy
                                                                        ]),
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff9e9e9e),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      17.0))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0.0),
                                                            child: Text(
                                                              'End Date   : ',
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff9e9e9e),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      17.0),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          //status
                                                          Text(
                                                              snapshot.data[index].endDate ==
                                                                      null
                                                                  ? ""
                                                                  : formatDate(
                                                                      DateTime.parse(snapshot
                                                                          .data[index]
                                                                          .endDate),
                                                                      [
                                                                          dd,
                                                                          " ",
                                                                          M,
                                                                          " ",
                                                                          yyyy
                                                                        ]),
                                                              style: const TextStyle(
                                                                  color: const Color(
                                                                      0xff9e9e9e),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Roboto",
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      17.0))
                                                        ],
                                                      ),

                                                      SizedBox(
                                                        height: 50.0,
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
                                                                // color: Color(
                                                                //     0xFFE3F2FD),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      'DropBox Link',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: Color(
                                                                            0xff1e88c6),
                                                                        fontWeight:
                                                                            FontWeight.w400,
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
                                                      ]),
                                                      SizedBox(
                                                        height: 30,
                                                      ),
                                                      Text("Progress",
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
                                                      SizedBox(height: 10),
                                                      // LinearProgressIndicator(
                                                      //   backgroundColor:
                                                      //       Colors.red,
                                                      //   valueColor:
                                                      //       AlwaysStoppedAnimation<
                                                      //           Color>(
                                                      //     Colors.amber,
                                                      //   ),
                                                      //   value: 0.8,
                                                      // ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(1.0),
                                                        color: const Color(
                                                            0xff9e9e9e),
                                                        child:
                                                            LinearProgressIndicator(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  const Color(
                                                                      0xff1e88c6),
                                                                ),
                                                                value: snapshot
                                                                            .data[
                                                                                index]
                                                                            .completedStatus ==
                                                                        null
                                                                    ? 0.5
                                                                    : snapshot
                                                                            .data[index]
                                                                            .completedStatus /
                                                                        100),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          snapshot.data[index]
                                                                      .completedStatus ==
                                                                  null
                                                              ? Text(
                                                                  snapshot
                                                                          .data[
                                                                              index]
                                                                          .completedStatus
                                                                          .toString() +
                                                                      '% ',
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
                                                                      '%',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Color(
                                                                          0xff1e88c6)),
                                                                ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                // // Container(
                                                // //   width: MediaQuery.of(context)
                                                // //       .size
                                                // //       .width,
                                                // //   child: LinearPercentIndicator(
                                                // //     padding: const EdgeInsets
                                                // //             .symmetric(
                                                // //         horizontal: 7.1),
                                                // //     animation: true,
                                                // //     animationDuration: 1000,
                                                // //     lineHeight: 8.0,
                                                // //     percent: i,
                                                // //     linearStrokeCap:
                                                // //         LinearStrokeCap
                                                // //             .roundAll,
                                                // //     progressColor:
                                                // //         Color(0xff216693),
                                                // //   ),
                                                // )
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
    // await FlutterLaunch.launchWathsApp(
    //     phone: number,
    //     message: 'Hello  I have some feedback regarding my project');

    await launch(urlWhatup(
        phone: number,
        message: "Hello  I have some feedback regarding my project"));
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
