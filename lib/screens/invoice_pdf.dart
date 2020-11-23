
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zartek_pms/models/milestone.dart';
import 'package:zartek_pms/screens/help_and_support.dart';
import 'package:zartek_pms/services/apis.dart';


class MyHomePage extends StatefulWidget {
   String  projectid;
  String projectname;
  String number;

  MyHomePage({this.projectid, this.projectname,this.number});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String urlpdfPath;
  String number;

  @override
  void initState() {
    super.initState();

    getFileFromUrl(
//     "https://firebasestorage.googleapis.com/v0/b/list-66122.appspot.com/o/Project1%2F1103181300431510Time%20And%20Work%20.pdf?alt=media&token=d34092b9-2391-47c4-aafb-db9963d770d7"
        'ashik').then((f) {
      setState(() {
        urlpdfPath = f.path;
        print(urlpdfPath);
      });
    });

    var body = {	"project_id": widget.projectid};
    print('gggggggggg'+body.toString());

    Apis().milestone(body: body).then((res) {
      print(res);
      setState(() {
        milestone = (res["milestones"] as List)
            .map((item) => Milestone.fromJson(item))
            .toList();
      });
    });


  }
  List<Milestone>  milestone = [];
  Future<File> getFileFromUrl(String url) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/pdf");
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("error opening url file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Welcome to Flutter',
        home: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                widget.projectname,
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
              )
          ),
          floatingActionButton: Container(
            height: 70.0,
            width: 70.0,
            child: FittedBox(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Help(mail: widget.number ,)),
                  );
                },
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Color(0xFFE3F2FD),
                        child: Icon(
                          Icons.chat,
                          color: Color(0xff1e88c6),
                        )),
                    // Container(
                    //
                    Row(
                      children: <Widget>[
                        Text('Raise your concerns',
                            style: const TextStyle(
                                color: const Color(0xff1e88c6),
                                fontWeight: FontWeight.w600,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 8.0)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: ListView.separated(
              separatorBuilder: (context,index)=>
                  Divider(color: Colors.black12),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: milestone.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(
                    Icons.picture_as_pdf,
                    color: const Color(0xFFD50000),
                  ),
                  title: Text("Invoice"),
                  onTap: () {
                    if (milestone[index].milestoneDetails != null) {
                      Fluttertoast.showToast(
                          msg: 'Loading...',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.white10,
                          textColor: Colors.black,

                          fontSize: 15.0);

                      getFileFromUrl(milestone[index].milestoneDetails).then((f) {
                        setState(() {
                          urlpdfPath = f.path;
                          print(urlpdfPath);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfViewPage(path: urlpdfPath,projectname: widget.projectname
                                  ,),
                              ));
                        });
                      });
                    }
                  },
                );
              }),
        ));
  }
}

// /data/user/0/com.example.lastone/app_flutter/pdf

class PdfViewPage extends StatefulWidget {
  final String path;
  String projectname;

   PdfViewPage({Key key, this.path,this.projectname}) : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool pdfReady = false;
  String projectname;

  int pages = 0;
  @override
  Widget build(BuildContext context) {
    var pdfView = PDFView(
      filePath: widget.path,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
      onRender: (_pages) {
        setState(() {
          pages = _pages;
          pdfReady = true;
          //PDFViewController _pdfViewController;
        });
      },
      onError: (error) {
        print(error.toString());
      },
      onPageError: (page, error) {
        print('$page: ${error.toString()}');
      },
      onPageChanged: (int page, int total) {
        print('page change: $page/$total');
      },
    );
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.projectname,
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
          )
      ),
      body: Stack(
        children: <Widget>[
          pdfView,
          !pdfReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
        ],
      ),
    );
  }
}
