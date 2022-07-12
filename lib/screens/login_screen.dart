import 'package:flutter/material.dart';
import 'package:fluxchat/components/rounded_button.dart';
import 'package:fluxchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'Login Screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible /*The Flexible widget will prevent overflowing of widgets*/
                  (
                child: Hero(
                  tag: logoAnimationTag,
                  child: Container(
                    height: 500.0,
                    width: 300.0,
                    child: Image.asset('images/logo.jpg'),
                  ),
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    inputDecoration.copyWith(hintText: 'Enter your email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration:
                    inputDecoration.copyWith(hintText: 'Enter your password'),
                onChanged: (value) {
                  password = value;
                },
              ),
              RoundedButton(
                  buttonColor: Colors.lightBlue,
                  shadowColor: Colors.lightBlue,
                  title: 'Log In',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    print('Email: $email');
                    print('Password: $password');
                    try {
                      if (password != '' &&
                          password != null &&
                          email != '' &&
                          email != null &&
                          !password.contains(' ') &&
                          !email.contains(' ')) {
                        final newUser = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Invalid email or password!"),
                        ));
                      }
                    } catch (e) {
                      print(e);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
