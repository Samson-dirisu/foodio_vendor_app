import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodie_vendor_app/providers/app_provider.dart';
import 'package:foodie_vendor_app/providers/auth_provider.dart';
import 'package:foodie_vendor_app/screens/auth_screens/sign_up_screen.dart';
import 'package:foodie_vendor_app/screens/landing_screens/home_screen.dart';
import 'package:foodie_vendor_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
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
        SignUpScreen.id: (context) => SignUpScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}

// start 18
