import 'package:ayuraveda_e_channeling/screens/register_form.dart';
import 'package:flutter/material.dart';

import 'doctor_registration.dart';

void main() {
  runApp(DoctorPatient());
}

class DoctorPatient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Doctor Or Patient'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to RegistrationFormApp screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorRegistrationForm()),
                  );
                },
                child: Text('Doctor'),
              ),

             // Add spacing between buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate to RegistrationFormApp screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientRegistrationForm()),
                  );
                },
                child: Text('Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

