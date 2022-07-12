import 'package:flutter/material.dart';
import 'package:fluxchat/screens/login_screen.dart';
import 'package:fluxchat/screens/registration_screen.dart';
import 'package:fluxchat/screens/chat_screen.dart';
import 'package:fluxchat/screens/welcome_screen.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const FluxChat());
}

class FluxChat extends StatelessWidget {
  const FluxChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /*
      Keep the screen ids static so that multiple instances of
      the screens are not required (for initial route and routes entry
       */
      initialRoute: WelcomeScreen.id,
      routes: {
        //Home is welcome screen
        WelcomeScreen.id: (context) => WelcomeScreen(),
        //Login screen
        LoginScreen.id: (context) => LoginScreen(),
        //Chat Screen
        ChatScreen.id: (context) => ChatScreen(),
        //Registration Screen
        RegistrationScreen.id: (context) => RegistrationScreen(),
      },
      // theme: ThemeData.dark().copyWith(
      //   textTheme: TextTheme(
      //     bodyText1: TextStyle(color: Colors.black54),
      //   ),
      // ),
    );
  }
}
