import 'package:flutter/material.dart';




Widget customProgress(){
  return Center(
    child: CircularProgressIndicator(
        valueColor:new AlwaysStoppedAnimation<Color>(Color(0xff1e88c6))
    ),
  );}