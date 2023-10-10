import 'package:flutter/material.dart';
import 'package:todoappdemo/Presentation/Screens/homescreen.dart';
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Duration splashDuration = Duration(seconds: 3);

    Future.delayed(splashDuration, () {
      // After the delay, navigate to the next screen.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          // Replace 'NextScreen' with the screen you want to navigate to.
          return TodoAppHomeScreen();
        }),
      );
    });

    return Scaffold(
      backgroundColor: Colors.transparent, // Set the background to transparent
      body: Stack(
        children: [
          
          Container(
            color:Color(0xFF0277BD),
            child: Center(
              child: Image.asset(
                'images/—Pngtree—hand drawn white gray check_7058370.png', // Replace with the path to your image asset
                width: 300, // Set the image width
                height: 200, // Set the image height
              ),
            ),
          ),


        ],
      ),
    );
  }
}