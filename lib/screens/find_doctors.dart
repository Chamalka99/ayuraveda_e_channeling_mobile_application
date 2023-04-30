import 'package:flutter/material.dart';



class AppoinmentScreen extends StatelessWidget {
  const AppoinmentScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Set the background color
      body: Center(
        child: Text(
          'Hello, World!', // Set the text
          style: TextStyle(
            color: Colors.white, // Set the text color
            fontSize: 24, // Set the font size
          ),
        ),
      ),
    );
  }
}
