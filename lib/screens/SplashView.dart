
import 'package:flutter/material.dart';
import 'package:the_movie_db_app/screens/HomeView.dart';
import 'package:the_movie_db_app/theme/CustomColors.dart';

class SplashView extends StatefulWidget {
  const SplashView({ Key? key }) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HomeView())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'resources/images/the_movie_db_logo.png',
          width: 275,
        ),
      )
    );
  }
}