import 'package:flutter/material.dart';
import 'package:fluxchat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluxchat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'Registration Screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance; //used to authenticate the users
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
              Flexible(
                //Flexible widget will prevent overflowing of widgets when keyboard is activated
                child: Hero(
                  tag: logoAnimationTag,
                  child: Container(
                    height: 500.0,
                    width: 300.0,
                    child: Image.asset('images/logo.jpg'),
                  ),
                ),
              ),
              // InputField(
              //   hintText: 'Enter your email',onChanged: (value),
              // ),
              TextField(
                keyboardType:
                    TextInputType.emailAddress, //shows the default keyboard
                //with the @ symbol specifically for email
                textAlign: TextAlign.center,
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
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                //for password
                textAlign: TextAlign.center,
                decoration:
                    inputDecoration.copyWith(hintText: 'Enter your password '),
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  buttonColor: Colors.blueAccent,
                  shadowColor: Colors.blueAccent,
                  title: 'Register',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      if (password != '' &&
                          password != null &&
                          email != '' &&
                          email != null &&
                          !password.contains(' ') &&
                          !email.contains(' ')) {
                        final authUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email,
                                password: password); //returns a future
                        print('User registerd!');
                        if (authUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Invalid email or password!"),
                        ));
                        email = '';
                        password = '';
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
