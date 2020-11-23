
//not used


// import 'package:flutter/material.dart';
//
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:zartek/screens/login.dart';
//
// class ForgotPage extends StatefulWidget {
//   @override
//   _ForgotPageState createState() => _ForgotPageState();
// }
//
// class _ForgotPageState extends State<ForgotPage> {
//
//
// final formKey=new GlobalKey<FormState>();
//  String _email;
//
//
//
//  Future<void> validateAndForget() async {
//
//     final form=formKey.currentState;
//
//     if(form.validate()){
//       form.save();
//       try{
//         //firebase
//         //  await FirebaseAuth.instance.sendPasswordResetEmail(email:_email);
//
//         Fluttertoast.showToast(
//         msg: 'Please check your mail',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIos: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 14.0
//     );
//          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
//
//
//       }
//       catch(e){
//
//         Fluttertoast.showToast(
//         msg: e.message,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIos: 1,
//         backgroundColor: Color(0xfff2f2f2),
//         textColor: Colors.red,
//         fontSize: 14.0
//     );
//
//        print(e.message);
//
//       }
//     }
//
//
//
//
//
//     }
//   @override
//   Widget build(BuildContext context) {
//
//      Widget _showEmailInput() {
//   return Padding(
//     padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
//     child: new TextFormField(
//       maxLines: 1,
//       keyboardType: TextInputType.emailAddress,
//       autofocus: false,
//       validator: (value)=> value.isEmpty ? 'Email cant be empty':null,
//       onSaved: (value)=> _email = value,
//       decoration: new InputDecoration(
//
//           hintText: 'Email Address',
//           icon: new Icon(
//             Icons.mail,
//             color: Colors.grey,
//           )
//
//
//
//         ),
//
//     ),
//   );
// }
//     Widget _resetButton(){
//        return new Padding(
//       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//       child: new MaterialButton(
//         elevation: 6.0,
//         minWidth: 130.0,
//         height: 40.0,
//         color: Colors.blue,
//          shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(22.0),),
//         child: new Text('Reset Password',
//
//                 style: new TextStyle(fontSize: 22.0, color: Colors.white)
//                 ),
//
//         onPressed: (){
//           validateAndForget();
//
//         },
//       ));
//     }
//     return Scaffold(
//
//       backgroundColor: Colors.white,
//       body:Stack(
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//
//               Padding(   child:new Image.asset(
//                 'images/forgot.png',
//                 width: 160.0,
//                 height: 160.0,
//                  ), padding: EdgeInsets.only(left: 50.0,right: 50.0,top:60.0),),
//                  SizedBox(height:15),
//               new Text("Forgot  password?",
//                 style: const TextStyle(
//                   color:  const Color(0xff000000),
//                   fontWeight: FontWeight.w500,
//                   fontFamily: "Roboto",
//                   fontStyle:  FontStyle.normal,
//                   fontSize: 24.0,
//
//               )
//              ),
//              SizedBox(height:25),
//
//              new Expanded(
//                 flex: 0,
//
//                 child: new Text(
//                   "Please enter your registered email address to reset your password.",
//
//                    textAlign:TextAlign.center,
//                    style: const TextStyle(
//
//                    color:  const Color(0xff000000),
//                    fontWeight: FontWeight.w400,
//                    fontFamily: "Roboto",
//                    fontStyle:  FontStyle.normal,
//                    fontSize: 18.0
//                ))  ,
//               )
//             ],
//           ),
//           Column(
//             children: <Widget>[
//               Expanded(
//                 flex: 40,
//                 child:SizedBox(height:60),
//               ),
//               Expanded(
//                 flex: 40,
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 30,right: 30,bottom: 40),
//                   child: Card(
//                     elevation: 6,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(22)
//                     ),
//                      color : Color(0xfff2f2f2),
//                      child:SingleChildScrollView(
//                        child: new Form(
//                          key: formKey,
//                            child: new Column(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            SizedBox(height:80,),
//                            _showEmailInput(),
//                            SizedBox(height:60),
//                            _resetButton(),
//
//
//                          ],
//
//
//                      ),
//                        ),
//                      )
//
//                   ),
//                 ),
//               )
//             ],
//           )
//         ],
//
//       ),
//
//     );
//   }
//
//
//
//
// }
