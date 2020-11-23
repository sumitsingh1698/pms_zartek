import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:zartek_pms/screens/splash_screen.dart';

//import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zartek',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
