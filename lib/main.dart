import 'package:flutter/material.dart';



import 'Presentation/Screens/homescreen.dart';
import 'Presentation/Screens/notification.dart';
import 'Presentation/Screens/splash.dart';
import 'Presentation/Screens/tas.dart';
import 'databse.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await DatabaseHelper.instance.database;
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  Notifications.initNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF0277BD), // Set your desired app bar color here
          appBarTheme: AppBarTheme(
            elevation: 0, // Remove app bar shadow
            color: Color(0xFF0277BD), // Set app bar color here
          ),

        ),
        routes: {
        '/': (context) => SplashScreen(), // Task screen route
        '/home': (context) => TodoAppHomeScreen(),
          '/tasks':(context) => Task(onItemAdded: (String ) {  },)// Home screen route
        },

    );
  }


}
