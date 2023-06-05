

import 'package:flutter/material.dart';


// screens

import 'screens/login_page.dart';
import 'screens/register_form.dart';
import 'navbar/navigation_bar.dart';
import 'screens/home.dart';
import 'screens/patient_profile.dart';
import 'screens/all_records.dart';
import 'package:ayuraveda_e_channeling/screens/cart.dart';







void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Hela Suwa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => NavBar(),
          '/profile': (context) => PatientProfile(),
          '/register': (context) => RegScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => PatientProfile(),
          '/records': (context) => AllRecords(),
          '/cart': (context) => ShoppingCartScreen(),



    });
  }
}