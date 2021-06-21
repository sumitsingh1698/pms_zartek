import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/material.dart';
import 'package:zartek_pms/file_view/my_file_viewer.dart';

const debug = true;

//
class Details extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;

  List files = [];
  Details({this.files, this.platform});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<_TaskInfo> _tasks;

  bool _isLoading;

  @override
  void initState() {
    print(widget.files);
    super.initState();
    _prepare();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Builder(
            builder: (context) => _isLoading
                ? new Center(
                    child: new CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xff1e88c6))))
                : _buildDownloadList()),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value, style: TextStyle(color: Color(0xFF051574))),
      backgroundColor: Colors.white,
    ));
  }

  Widget _buildDownloadList() => Container(
        child: widget.files.length == 0
            ? Center(
                child: Text('No Documents',
                    style: const TextStyle(
                        color: const Color(0xff1e88c6),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0)),
              )
            : ListView(
                // padding: const EdgeInsets.symmetric(vertical: 16.0),
                children: _tasks
                    .map((item) => MyFileViewer(
                          url: item.link,
                          fileName: item.name,
                        ))
                    .toList(),
              ),
      );

  Future<Null> _prepare() async {
    _tasks = [];

    _tasks.addAll(widget.files.map((document) =>
        _TaskInfo(name: document['name'], link: document['documents'])));

    setState(() {
      _isLoading = false;
    });
  }
}

class _TaskInfo {
  final String name;
  final String link;
  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;
  _TaskInfo({this.name, this.link});
}
