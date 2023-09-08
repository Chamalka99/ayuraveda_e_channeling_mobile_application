import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_page.dart';

void main() {
  runApp(const PatientProfile());
}




class Patient {
  final String name;
  final String lastName;
  final String email;
  final String address;

  Patient({
    required this.name,
    required this.lastName,
    required this.email,
    required this.address,
  });
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      name: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
      address: json['address'],
    );
  }
}

class ApiService {
  final String apiUrl; // The URL of your API

  ApiService(this.apiUrl);

  Future<Patient> getPatientDetails(String patientId) async {


    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Patient.fromJson(jsonData);
    } else {
      throw Exception('Failed to load patient details');
    }
  }
}



class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});


  @override
  Widget build(BuildContext context) {
    return ProfileScreen01() ;
  }
}

class ProfileScreen01 extends StatelessWidget {
  final ApiService apiService = ApiService("http://localhost/ayuravedaapp/test.php/singlepatient/23");
  @override
  Widget build(BuildContext context) {
    final Future<Patient> dummyPatient = Future.delayed(Duration(seconds: 2), () {
      return Patient(
        name: "Sample Patient",
        lastName: "1234567890",
        email: "2000-01-01",
        address: "Sample Address",
      );
    });

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Patient Profile'),
        ),
        body: SingleChildScrollView( // Wrap the FutureBuilder with SingleChildScrollView
        child: FutureBuilder<Patient>(
        future: apiService.getPatientDetails("http://localhost/ayuravedaapp/test.php/singlepatient/16"),
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final patient = snapshot.data!;
              return ListTile(

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 375,
                      height: 812,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(color: Color(0xFFF9F7F7)),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 40,
                            top: 678,
                            child: Container(
                              width: 295,
                              height: 54,
                              child: Stack(
                                children: [


                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 372,
                            child: Container(
                              width: 338,
                              height: 300,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 173,
                                    child: Container(
                                      width: 335,
                                      height: 60,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 335,
                                              height: 60,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20,
                                            top: 9,
                                            child: Text(
                                              'Email',
                                              style: TextStyle(
                                                color: Color(0xFF0F7986),
                                                fontSize: 10,
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: -0.30,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20,
                                            top: 28,
                                            child: Text(
                                              patient.email /* here show date of birth of pateint*/,
                                              style: TextStyle(
                                                color: Color(0xFF677294),
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: -0.30,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 103,
                                    child: Container(
                                      width: 335,
                                      height: 60,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 335,
                                              height: 60,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20,
                                            top: 9,
                                            child: Text(
                                              'Last Name',
                                              style: TextStyle(
                                                color: Color(0xFF0F7986),
                                                fontSize: 10,
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: -0.30,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20,
                                            top: 28,
                                            child: SizedBox(
                                              width: 132,
                                              height: 18,
                                              child: Text(
                                                patient.lastName ,
                                                style: TextStyle(
                                                  color: Color(0xFF677294),
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w300,
                                                  letterSpacing: -0.30,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 33,
                                    child: Container(
                                      width: 335,
                                      height: 60,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 335,
                                              height: 60,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20,
                                            top: 9,
                                            child: Text(
                                              'First Name',
                                              style: TextStyle(
                                                color: Color(0xFF0F7986),
                                                fontSize: 10,
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: -0.30,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20,
                                            top: 28,
                                            child: Text(
                                             patient.name/* here show name of pateint*/,
                                              style: TextStyle(
                                                color: Color(0xFF677294),
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: -0.30,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 3,
                                    top: 240,
                                    child: Container(
                                      width: 335,
                                      height: 60,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 335,
                                              height: 60,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20,
                                            top: 9,
                                            child: Text(
                                              'Address',
                                              style: TextStyle(
                                                color: Color(0xFF0F7986),
                                                fontSize: 10,
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: -0.30,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 20,
                                            top: 28,
                                            child: Text(
                                              patient.address /* here show date address of pateint*/,
                                              style: TextStyle(
                                                color: Color(0xFF677294),
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: -0.30,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Text(
                                      'Patient information',
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 18,
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 375,
                              height: 357,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 375,
                                      height: 357,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFF0F7986),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 120,
                                    top: 100,
                                    child: Text(
                                      'Set up your profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 123,
                                    top: 197,
                                    child: Container(
                                      width: 138,
                                      height: 130,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 130,
                                              height: 130,
                                              decoration: ShapeDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage("http://localhost/ayuravedaapp/assets/E1.png"),

                                                ),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 102,
                                            top: 81,
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 0,
                                                    top: 0,
                                                    child: Container(
                                                      width: 36,
                                                      height: 36,


                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 36,
                            child: Container(
                              width: 107,
                              height: 30,
                              child: Stack(
                                children: [

                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            left: 0,
                            top: 754,
                            child: Container(
                              width: 375,
                              height: 58,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 375,
                                      height: 58,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 375,
                                              height: 58,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0x0C323247),
                                                    blurRadius: 8,
                                                    offset: Offset(0, -3),
                                                    spreadRadius: -1,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 42,
                                            top: 16,
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(),
                                              child: Stack(children: [

                                              ]),
                                            ),
                                          ),
                                          Positioned(
                                            left: 175,
                                            top: 16,
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 5,
                                                    top: 5,
                                                    child: Container(
                                                      width: 22,
                                                      height: 22,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(),
                                                      child: Stack(children: [

                                                      ]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 304.30,
                                            top: 17.10,
                                            child: Container(
                                              width: 32.79,
                                              height: 23.79,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    left: 5.05,
                                                    top: 0.13,
                                                    child: Container(
                                                      width: 26,
                                                      height: 26,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(),
                                                      child: Stack(children: [

                                                      ]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 109,
                                    top: 20,
                                    child: Container(
                                      width: 23.55,
                                      height: 23.56,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: []),
                                    ),
                                  ),
                                  Positioned(
                                    left: 248,
                                    top: 21,
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                      child: Stack(children: []),
                                    ),
                                  ),
                                  Container(
                                    // The parent container
                                    width: double.infinity, // Adjust as needed
                                    height: double.infinity, // Adjust as needed
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          bottom: 25,
                                          child: Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Add your logout logic here
                                                // After logging out, navigate to the LoginPage
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                                );
                                              },
                                              child: Text("Logout"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )


                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                ),
              );
            }

          },
        ),
      ),
    ),

    );

  }

}