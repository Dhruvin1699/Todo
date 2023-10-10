import 'package:flutter/material.dart';
import 'package:todoappdemo/Presentation/Screens/homescreen.dart';
import 'package:todoappdemo/Presentation/Screens/splash.dart';
import 'package:todoappdemo/Presentation/Screens/tas.dart';
import 'package:todoappdemo/databse.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
        '/': (context) => SplashScreen(), // Task screen route
        '/home': (context) => TodoAppHomeScreen(),
          '/tasks':(context) => Task(onItemAdded: (String ) {  },)// Home screen route
        },

    );
  }
}