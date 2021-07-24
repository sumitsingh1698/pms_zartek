import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zartek_pms/models/milestone.dart';
import 'package:zartek_pms/models/project_status.dart';
import 'package:zartek_pms/models/my_profile.dart';

//Api
class Apis {
  String BASE_URL = "https://zartek-pms.herokuapp.com/api/";

//projects
  Future<List<Results>> Projects() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    print('token_number$token');

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "token " + token
    };
    print("json=$json");

    final response = await http.get(BASE_URL + "project/", headers: headers);
    print("headers" + headers.toString());
    print("project :" + response.body);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      log('gzdbghsth' + responseJson.toString());
      return (responseJson['results'] as List)
          .map((li) => Results.fromJson(li))
          .toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

// invoices
  Future<List<Invoices>> Invoice() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    print('token_number$token');

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "token " + token
    };
    print("json=$json");

    final response = await http.get(BASE_URL + "project/", headers: headers);
    print("headers" + headers.toString());
    print("project :" + response.body);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print('gzdbghsth' + responseJson.toString());
      return (responseJson['results'][0]['invoices'] as List)
          .map((li) => Invoices.fromJson(li))
          .toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  //documents
  Future<List<Document>> Documents() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    print('token_number$token');

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "token " + token
    };
    print("json=$json");

    final response = await http.get(BASE_URL + "project/", headers: headers);
    print("headers" + headers.toString());
    print("project :" + response.body);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      print('gzdbghsth' + responseJson.toString());
      return (responseJson['results'][0]['document'] as List)
          .map((li) => Document.fromJson(li))
          .toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  //milestone
  Future<List<Milestone>> milestone() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "token " + token
    };
    print("json=$json");

    final response = await http.get(BASE_URL + "milestone/", headers: headers);
    print("milestone :" + response.body);
    if (response.statusCode == 200) {
      print('gzdbghsth' + response.body);
      var responseJson = json.decode(response.body);
      return (responseJson['milestone'] as List)
          .map((li) => Milestone.fromJson(li))
          .toList();
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  //client details
  Future<Myprofile> profile() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "token " + token
    };
    print("json=$json");

    final response = await http.get(BASE_URL + "users/me/", headers: headers);
    print("profile :" + response.body);
    if (response.statusCode == 200) {
      print('gzdbghsth' + response.body);
      var responseJson = json.decode(response.body);
      return Myprofile.fromJson(responseJson);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
