import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:zartek_pms/styles.dart';

class MyFileViewer extends StatefulWidget {
  MyFileViewer({Key key, @required this.url, this.fileName = "myfile"})
      : super(key: key);
  final String url, fileName;

  @override
  _MyFileViewerState createState() => _MyFileViewerState();
}

class _MyFileViewerState extends State<MyFileViewer> {
  String _fileName;
  final Dio _dio = Dio();

  String _progress = "";
  bool fileExist = false;
  Map<String, dynamic> _resultFile;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    print(path.extension(widget.url.split("?")[0]));
    _fileName = "${widget.fileName}" + path.extension(widget.url.split("?")[0]);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPath();
    });
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.High, importance: Importance.Max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Successfully Downloaded' : 'Failure Download',
        isSuccess
            ? '${widget.fileName} has been downloaded successfully!'
            : 'There was an error while downloading the ${widget.fileName}.',
        platform,
        payload: json);
  }

  Future<String> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
    }

    return await ExtStorage.getExternalStorageDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      permission = await Permission.storage.status;
    }

    return permission == PermissionStatus.granted;
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  Future<void> _startDownload(String savePath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await _dio.download(widget.url, savePath,
          onReceiveProgress: _onReceiveProgress);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      setState(() {
        this._resultFile = result;
      });

      await _showNotification(result);
    }
  }

  Future<String> getPath() async {
    String dirPath = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dirPath, _fileName);
      bool isExist = await File(savePath).exists();
      if (isExist) {
        _resultFile = {};
        _resultFile['isSuccess'] = true;
        _resultFile['filePath'] = savePath;
        setState(() {
          fileExist = isExist;
        });
      }

      return savePath;
    }
    return null;
  }

  Future<void> _download() async {
    setState(() {
      _resultFile = null;
      _progress = "";
      fileExist = false;
    });

    await _startDownload(await getPath());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "${widget.fileName}",
            style: plainTextStyle(),
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (this._resultFile == null)
                  FlatButton(
                    onPressed: null,
                    child: Text(
                      "${_progress}",
                      style: plainTextStyle(),
                    ),
                  ),
                if (this.fileExist ||
                    this._resultFile != null &&
                        this._resultFile['isSuccess'] == true)
                  FlatButton(
                    child: Text(
                      "view",
                      style: plainTextStyle(),
                    ),
                    onPressed: () {
                      _onSelectNotification(jsonEncode(this._resultFile));
                    },
                  )
                else if (this._resultFile != null)
                  FlatButton(
                    onPressed: null,
                    child: Text(
                      "failed",
                      style: plainTextStyle(),
                    ),
                  ),
                IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: _download,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
