
import 'package:flutter/material.dart';
// import 'package:heavy_equipment/src/homePage.dart';
// import 'package:heavy_equipment/src/signupPage.dart';
import 'package:heavy_equipment/src/authentication.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});
  
  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override 
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  // String _displayName;
  // bool _loading = false;
  // bool _autoValidate = false;
  String errorMsg = "";
  // PersistentBottomSheetController _sheetController;
  bool _isLoading;
  // bool _isLoginForm;
  String _errorMessage;

  @override 
  void initState() {
    _errorMessage = '';
    _isLoading = false;
    // _isLoginForm = true;
    super.initState();
  }
  // Widget _backButton() {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.pop(context);
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10),
  //       child: Row(
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
  //             child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
  //           ),
  //           Text(
  //             'Back',
  //             style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _entryField(String title, {bool isPassword = false}) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           title,
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //         ),
  //         SizedBox(height: 10,),
  //         TextField(
  //           obscureText: isPassword,
  //           decoration: InputDecoration(
  //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  //             fillColor: Color(0xfff3f3f4),
  //             filled: true,
  //             hintText: title,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _loginButton() {
    return InkWell(
      onTap: validateAndSubmit,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  // Widget _createAccountLabel() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 20),
  //     alignment: Alignment.center,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Text(
  //           'Don\'t have account ?',
  //           style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
  //         ),
  //         SizedBox(width: 10,),
  //         InkWell(
  //           onTap: () {
  //             Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
  //           },
  //           child: Text(
  //             'Register',
  //             style: TextStyle(
  //               color: Color(0xfff79c4f),
  //               fontSize: 13,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _emailPasswordWidget() {
  //   return Column(
  //     children: <Widget>[
  //       _entryField('Username'),
  //       _entryField('Password', isPassword: true),
  //     ],
  //   );
  // }

  String emailValidator(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if(value.isEmpty) {
      return '*required';
    }
    if(!regex.hasMatch(value)) {
      return '*Enter Valid Email Address';
    } else {
      return null;
    }
  }

  // void validateLoginInput() async {
  //   final FormState form = _formKey.currentState;
  //   if(_formKey.currentState.validate()) {
  //       form.save();
  //       _sheetController.setState(() {
  //         _loading = true;
  //       });
  //       try {
  //         AuthResult user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
  //         Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  //       } catch(error) {
  //           switch(error.code) {
  //             case "ERROR_USER_NOT_FOUND":
  //             {
  //               _sheetController.setState(() {
  //                 errorMsg =
  //                     "There is no user with such entries. Please try again.";

  //                 _loading = false;
  //               });
  //               showDialog(
  //                   context: context,
  //                   builder: (BuildContext context) {
  //                     return AlertDialog(
  //                       content: Container(
  //                         child: Text(errorMsg),
  //                       ),
  //                     );
  //                   });
  //             }
  //               break;
  //             case "ERROR_WRONG_PASSWORD":
  //             {
  //               _sheetController.setState(() {
  //                 errorMsg = "Password doesn\'t match your email.";
  //                 _loading = false;
  //               });
  //               showDialog(
  //                   context: context,
  //                   builder: (BuildContext context) {
  //                     return AlertDialog(
  //                       content: Container(
  //                         child: Text(errorMsg),
  //                       ),
  //                     );
  //                   });
  //             }
  //               break;
  //             default:
  //           }
  //       }
  //   } else {
  //     setState(() {
  //       _autoValidate = true;
  //     });
  //   }
  // }

  Widget showCircularProgress() {
    if(_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(width: 0, height:0);

  }

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          icon: Icon(Icons.email, color: Colors.grey,),
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(Icons.lock, color: Colors.grey),
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showErrorMessage() {
    if(_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13,
          height: 1,
          color: Colors.red,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return Container(height: 0,);
    }
  }

  Widget _showForm() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            showEmailInput(),
            showPasswordInput(),
            _loginButton(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async{
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });
    if(validateAndSave()) {
      String userId = '';
      try {
        userId = await widget.auth.signIn(_email, _password);
        print('Signed In: $userId');
        setState(() {
          _isLoading = false;
        });
        if(userId.length > 0 && userId != null) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }



  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xfffbb448), Color(0xffe46b10)],
            ),
          ),
          child: Stack(
            children: <Widget>[
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Expanded(
              //         flex: 3,
              //         child: SizedBox(),
              //       ),
              //       SizedBox(height: 50),
              //       _emailPasswordWidget(),
              //       SizedBox(height: 20),
              //       _loginButton(),
              //       Container(
              //         padding: EdgeInsets.symmetric(vertical: 10),
              //         alignment: Alignment.centerRight,
              //         child: Text(
              //           '* Forgot Password',
              //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              //         ),
              //       ),
              //       Expanded(
              //         flex: 2,
              //         child: SizedBox(),
              //       ),
              //       Align(
              //         alignment: Alignment.bottomCenter,
              //         child: _createAccountLabel(),
              //       ),
              //     ],
              //   )
              // ),
              // Positioned(top: 40, left: 0, child: _backButton()),
              _showForm(),
              showCircularProgress(),
            ],
          ),
        ),
      ),
    );
  }
}