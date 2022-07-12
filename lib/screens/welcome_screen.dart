import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluxchat/screens/login_screen.dart';
import 'package:fluxchat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/rounded_button.dart';
import '../constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static String id = 'Welcome Screen'; //keeping
  //static so that only one instance of the screen is created while setting
  //initialRoute and entry in the routes map
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin
/*
    Mixins add multiple capabilities to the class
    */
/*
This shows that the welcome screen can also work as a SingleTicker Provider
* */
{
  AnimationController? animationController;
  //Animation<Color?>? animation; //for color tween animation
  Animation<double>? animation;

  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    super.initState();
    //Initialise the animationController
    animationController = AnimationController(
      vsync: this, //TickerProvider is added using vsync, this current
      //welcome screen state object as we have added the mixin to the class
      duration: Duration(seconds: 5),
      // upperBound: 100, /not used with curvedanimation
    );
    animationController!.forward(); //the controller will

    //Add a listener to the controller to listen what
    //it is doing
    animationController!.addListener(
      () {
        //Listen to the value of the controller
        setState(
          () {
            //Empty but added so that the screen can be
            //rebuilt on every change
          },
        );
        print(animation!.value);
      },
    );
    //for curved animation we cannot have an upper bound
    //greater than 1
    animation = CurvedAnimation(
      parent: animationController!, //the controller
      curve: Curves.decelerate, // the curve type
    );
    //Color tween animation
    // animation = ColorTween(begin: Colors.red, end: Colors.blueAccent)
    //     .animate(animationController!);
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose() method called!');
    animationController!.dispose(); //should also
    // dispose the controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: logoAnimationTag,
              child: Container(
                child: Image.asset(
                  'images/logo.jpg',
                  alignment: Alignment.center,
                ),
                height: animation!.value * 400, //500.0,
                width: animation!.value * 300,
                //width: animationController!.value,
              ),
            ),
            TextLiquidFill(
              loadUntil: 0.8,
              boxHeight: 100,
              text: 'Flux Chat',
              waveColor: Colors.blueAccent,
              boxBackgroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 48,
            ),
            RoundedButton(
              buttonColor: Colors.lightBlue,
              shadowColor: Colors.lightBlue,
              title: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              buttonColor: Colors.blueAccent,
              shadowColor: Colors.blueAccent,
              title: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
