import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Apis {
  String BASE_URL = "https://zartekpms.herokuapp.com/";
  // login
  Future<Map<String, dynamic>> registerUser({var body}) async {
    final response = await http.post(
      BASE_URL + "authenticate_client/",
      body: json.encode(body),
    );
    print("gvg" + response.body.toString());

    if (response.statusCode == 200) {
      print('statuscode:'+response.statusCode.toString());
      var responseJson = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString("token", responseJson['token']);
      return responseJson;
    } else {
      // If that call was not successful, throw an error.

      throw Exception('Failed to load post');
    }
  }

//projects
  Future Projects({var body}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    print('token_number$token');

    var headers = {"Content-Type": "application/json", "Authorization": token};
    print("json=$json");
    print("hbh" + body.toString());
    final response = await http.post(BASE_URL + "get_project/",
        body: json.encode(body), headers: headers);
    print("headers" + headers.toString());
    print("project :" + response.body);
    if (response.statusCode == 200) {
      print('gzdbghsth' + response.body);

      var responseJson = json.decode(response.body);

      return responseJson;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  //milestone
  Future milestone({var body}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    var headers = {"Content-Type": "application/json", "Authorization": token};
    print("json=$json");
    print("hbh" + body.toString());
    final response = await http.post(BASE_URL + "get_milestone/",
        body: json.encode(body), headers: headers);
    print("milestone :" + response.body);
    if (response.statusCode == 200) {
      print('gzdbghsth' + response.body);
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  //client details
  Future profile({var body}) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    var headers = {"Content-Type": "application/json", "Authorization": token};
    print("json=$json");
    print("hbh" + body.toString());
    final response = await http.post(BASE_URL + "client_details/",
        body: json.encode(body), headers: headers);
    print("profile :" + response.body);
    if (response.statusCode == 200) {
      print('gzdbghsth' + response.body);
      var responseJson = json.decode(response.body);
      return responseJson;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

}
