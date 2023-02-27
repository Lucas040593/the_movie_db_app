import 'package:flutter/material.dart';
import 'package:the_movie_db_app/provider/Movie_provider.dart';
import 'package:the_movie_db_app/screens/SplashView.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MovieProvider()),
    ChangeNotifierProvider(create: (context) => ThemeChanger(ThemeData.dark()))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      theme: theme.getTheme(),
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
    );
  }
}
