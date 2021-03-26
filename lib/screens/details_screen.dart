import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:zartek_pms/models/project_status.dart';

import '../models/milestone.dart';
import '../services/apis.dart';
import 'package:http/http.dart' as http;

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
  String urlpdfPath;
  String ashik = "";

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<_TaskInfo> _tasks;
  int progressPercentValue = 0;
  String Token = "";
  List<_ItemHolder> _items;
  bool _isLoading;
  bool _permissionReady = false;
  String _localPath;
  ReceivePort _port = ReceivePort();
  double _progressValue = 0;

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    _isLoading = true;
    _permissionReady = false;
    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          setState(() {
            task.status = status;
            task.progress = progress;
          });
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
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
                children: _items
                    .map((item) => item.task == null
                        ? _buildListSection(item.name)
                        : DownloadItem(
                            data: item,
                            onItemClick: (task) {
                              _openDownloadedFile(task).then((success) {
                                if (!success) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Cannot open this file')));
                                }
                              });
                            },
                            onAtionClick: (task) {
                              if (task.status == DownloadTaskStatus.undefined) {
                                _requestDownload(task);
                              } else if (task.status ==
                                  DownloadTaskStatus.running) {
                                _pauseDownload(task);
                              } else if (task.status ==
                                  DownloadTaskStatus.paused) {
                                _resumeDownload(task);
                              } else if (task.status ==
                                  DownloadTaskStatus.complete) {
                                _delete(task);
                              } else if (task.status ==
                                  DownloadTaskStatus.failed) {
                                _retryDownload(task);
                              }
                            },
                          ))
                    .toList(),
              ),
      );

  Widget _buildListSection(String title) => Center(
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '',
          ),
        ),
      );

  void _requestDownload(_TaskInfo task) async {
    print('this is task');

    task.taskId = await FlutterDownloader.enqueue(
        url: task.link,
        fileName: task.name,
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
  }

  void _cancelDownload(_TaskInfo task) async {
    await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void _pauseDownload(_TaskInfo task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void _resumeDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void _retryDownload(_TaskInfo task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  Future<bool> _openDownloadedFile(_TaskInfo task) {
    return FlutterDownloader.open(taskId: task.taskId);
  }

  void _delete(_TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    setState(() {});
  }

  Future<Null> _prepare() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    print(statuses[Permission.storage]);
    _localPath =
        (await _findLocalPath()) + Platform.pathSeparator + 'documents';
    print('this is your local ' + _localPath.toString());

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    final tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    _tasks = [];
    _items = [];

    _tasks.addAll(widget.files.map((document) =>
        _TaskInfo(name: document['name'], link: document['documents'])));
    _items.add(_ItemHolder(name: ''));
    for (int i = count; i < _tasks.length; i++) {
      _items.add(_ItemHolder(name: _tasks[i].name, task: _tasks[i]));
      count++;
    }
    tasks?.forEach((task) {
      for (_TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    // _permissionReady = await _checkPermission();

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _findLocalPath() async {
    final directory = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    return directory;
  }

}

class DownloadItem extends StatelessWidget {
  final _ItemHolder data;
  final Function(_TaskInfo) onItemClick;
  final Function(_TaskInfo) onAtionClick;
  DownloadItem({this.data, this.onItemClick, this.onAtionClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          child: InkWell(
            onTap: data.task.status == DownloadTaskStatus.complete
                ? () {
                    onItemClick(data.task);
                  }
                : null,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              data.name.split('/').last,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1e88c6),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    _buildActionForTask(data.task)
                  ],
                ),
                Container(
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets
                        .symmetric(
                        horizontal: 7.1),
                    animation: false,
                    animationDuration: 1000,
                    lineHeight: 1.0,
                    percent: data.task.progress / 100,
                    linearStrokeCap:
                    LinearStrokeCap
                        .roundAll,
                    progressColor:
                    Color(0xff216693),
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     //                    <-- BoxDecoration
                //     border: Border(bottom: BorderSide(color: Colors.black12)),
                //
                //   ),
                // ),
              ].where((child) => child != null).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionForTask(_TaskInfo task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        child: Icon(
          Icons.file_download,
          color: Color(0xff1e88c6),
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        child: Icon(
          Icons.pause,
          color: Color(0xff1e88c6),
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return RawMaterialButton(
        onPressed: () {
          onAtionClick(task);
        },
        child: Icon(
          Icons.play_arrow,
          color: Color(0xff1e88c6),
        ),
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Open',
            style: TextStyle(color: Color(0xff1e88c6)),
          ),
          RawMaterialButton(
            onPressed: () {
              onAtionClick(task);
            },
            child: Icon(
              Icons.delete_forever,
              color: Color(0xff1e88c6),
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return Text('Canceled', style: TextStyle(color: Color(0xff1e88c6)));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Failed', style: TextStyle(color: Color(0xff1e88c6))),
          RawMaterialButton(
            onPressed: () {
              onAtionClick(task);
            },
            child: Icon(
              Icons.refresh,
              color: Color(0xff1e88c6),
            ),
            shape: CircleBorder(),
            constraints: BoxConstraints(minHeight: 32.0, minWidth: 32.0),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.enqueued) {
      return Text('Pending', style: TextStyle(color: Color(0xff1e88c6)));
    } else {
      return null;
    }
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

class _ItemHolder {
  final String name;
  final _TaskInfo task;
  _ItemHolder({this.name, this.task});
}
