import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zartek_pms/bottomnavbar/home_widget.dart';
import 'package:zartek_pms/models/token.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zartek_pms/services/apis.dart';
import 'package:zartek_pms/webview/webview.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Login extends StatefulWidget {
  static final String routeName = "Login";
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Login> {
  TextEditingController mobController = TextEditingController();
  TextEditingController mobControllerr = TextEditingController();
//dec
  String _email;
  String _password;
  bool wrong = false;
  List<Errors> error = [];

  final formKey = new GlobalKey<FormState>();

  _textMe() async {
    // Android
    const uri = 'sms:?body=';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      const uri = 'sms:?body=';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
  //Validate save

  void validateAndSave() async {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      var body = {
        "email": mobController.text.toString(),
        "password": mobControllerr.text.toString()
      };
      final response = await http.post(
        "https://zartekpms.herokuapp.com/authenticate_client/",
        body: json.encode(body),
      );
      if (response.statusCode != 200) {
        setState(() {
          wrong = true;
        });
      }
      Apis().registerUser(body: body).then((res) async {

        SharedPreferences _shared = await SharedPreferences.getInstance();
        _shared.setString(
          "email",
          mobController.text.toString(),
        );
        _shared.setString(
          "password",
          mobControllerr.text.toString(),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    email: mobController.text.toString(),
                    password: mobControllerr.text.toString(),
                  )),
        );
      });
    } else {
      setState(() {
        wrong = true;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    //Email
    Widget _showEmailInput() {
      return Container(
        height: 60.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 1.0, 1.0, 0.0),
            child: new TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              controller: mobController,
              autofocus: false,
              validator: (value) => value.isEmpty ? '' : null,
              //saving
              // onSaved: (value) => _email = value,
              decoration: new InputDecoration(
                  errorStyle: TextStyle(height: 0, color: Colors.transparent),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelText: 'username',
                  fillColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: Color(0xff1e88c6),
                  )),
            ),
          ),
        ),
      );
    }

//Password

    Widget _showPasswordInput() {
      return Container(
        height: 60.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 1.0, 1.0, 0.0),
            child: new TextFormField(
              maxLines: 1,
              controller: mobControllerr,
              obscureText: true,
              autofocus: false,
              validator: (value) => value.isEmpty ? '' : null,
              //saving
              // onSaved: (value) => _password = value,

              decoration: new InputDecoration(
                  errorStyle: TextStyle(
                    height: 0,
                    color: Colors.white,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelText: 'password',
                  fillColor: Colors.blue,
                  labelStyle: TextStyle(
                    color: Color(0xff1e88c6),
                  )),
            ),
          ),
        ),
      );
    }

//Text

    Widget _logoText() => Container(
          height: 90.0,
          width: 155.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/logo.png'), fit: BoxFit.contain),
              shape: BoxShape.rectangle),
        );

    //Primary btn

    Widget _showPrimaryButton() {
      return new Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.6,
            height: 50,
            child: RaisedButton(
              color: Color(0xff216693),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: new Text('LOGIN',
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w200)),
              onPressed: () {
                validateAndSave();
              },
            ),
          ));
    }

//sec button
    //ygit remote add origin https://vishnunedumparambu@bitbucket.org/vishnunedumparambu/zartekapp.git

    Widget _showText() {
      return new FlatButton(
        child: new Text(' Start a project with us ',
            style: new TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto")),
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Web(),
              ));
        },
      );
    }

//Body
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFACC9DB),
              // Color(0xFF78A7C5),
              Color(0xFF256EA1),
            ],
            stops: [0.1, 2.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: SingleChildScrollView(
                  child: new Form(
                    autovalidate: true,
                    key: formKey,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        _logoText(),
                        SizedBox(
                          height: 30,
                        ),
                        _showEmailInput(),
                        SizedBox(
                          height: 5,
                        ),
                        _showPasswordInput(),
                        SizedBox(
                          height: 9.0,
                        ),

                        Row(
                          children: <Widget>[
                            Text(
                              'Forgot your login details ?',
                              style: new TextStyle(
                                  fontSize: 10.0, color: Colors.white),
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                UrlLauncher.launch("mailto:info@zartek.in");
                              },
                              child: Text(
                                  'Get in touch with your project manager',
                                  style: new TextStyle(
                                      fontSize: 10.0,
                                      color: Color(0xff216693),
                                      decoration: TextDecoration.underline)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Visibility(
                            visible: wrong,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 10,
                                ),
                                Text('invalid user name or password',
                                    style: new TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.red,
                                    ))
                              ],
                            )),
                        SizedBox(
                          height: 22,
                        ),

                        //SizedBox(height: ,),
                        Container(child: _showPrimaryButton()),
                        SizedBox(
                          height: 1,
                        ),

                        _showText()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
