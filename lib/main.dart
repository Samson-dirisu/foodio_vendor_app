import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodie_vendor_app/screens/auth_screen.dart';
import 'package:foodie_vendor_app/screens/home_screen.dart';
import 'package:foodie_vendor_app/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xff84c225), fontFamily: "Lato"),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        AuthScreen.id: (context) => AuthScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}

// done with 17, start 18.
