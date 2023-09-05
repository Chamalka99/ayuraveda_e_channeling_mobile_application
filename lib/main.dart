
import 'package:ayuraveda_e_channeling/screens/Store.dart';
import 'package:ayuraveda_e_channeling/screens/appoinment.dart';
import 'package:ayuraveda_e_channeling/screens/appoinment_view.dart';
import 'package:ayuraveda_e_channeling/screens/find_doctors.dart';
import 'package:flutter/material.dart';


// screens

import 'screens/login_page.dart';
import 'screens/register_form.dart';
import 'navbar/navigation_bar.dart';
import 'screens/home.dart';
import 'screens/patient_profile.dart';
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
          '/': (context) => PatientRegistrationForm(),
          '/profile': (context) => PatientProfile(),
          '/register': (context) => PatientRegistrationForm(),
          '/login': (context) => PatientRegistrationForm(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => PatientProfile(),
          '/cart': (context) => CartScreen(),
          '/doctorreg': (context) => YourWidget(),
          '/appoinment': (context) => DoctorConsultationFormApp(),
          '/appinmenr':(context)=> Appointment(),







    });
  }
}