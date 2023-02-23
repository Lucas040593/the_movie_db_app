import 'package:flutter/material.dart';
import 'package:the_movie_db_app/screens/SplashView.dart';
import 'package:the_movie_db_app/theme/CustomColors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // primarySwatch: Colors.blue, 
          scaffoldBackgroundColor: CustomColors.main,
          secondaryHeaderColor: CustomColors.secondary,
          fontFamily: 'Montserrat'
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashView(),
    );
  }
}