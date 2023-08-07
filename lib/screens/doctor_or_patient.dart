import 'package:ayuraveda_e_channeling/screens/register_form.dart';
import 'package:flutter/material.dart';

import 'doctor_registration.dart';

void main() {
  runApp(DoctorPatient());
}

class DoctorPatient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return MaterialApp(
      title: 'Doctor or Patient',
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        body: Stack(
          fit: StackFit.expand,
          children: [
            // Add your background image here, using an Image widget or a Container with decoration.
            // Example: Image.asset('assets/background_image.png', fit: BoxFit.cover),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: isSmallScreen ? 150 : 150,
                    height: isSmallScreen ? 150 : 150,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to DoctorRegistrationForm screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorRegistrationForm(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: Size(150, 50),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.medical_services),
                            SizedBox(width: 8),
                            Text('Doctor'),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to PatientRegistrationForm screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientRegistrationForm(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: Size(150, 50),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 8),
                            Text('Patient'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




