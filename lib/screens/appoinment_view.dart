
import 'package:ayuraveda_e_channeling/.env.example.dart';
import 'package:ayuraveda_e_channeling/screens/pay.dart';
import 'package:ayuraveda_e_channeling/screens/payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'join_screen.dart';
import 'package:flutter/material.dart';





class AppointmentCard extends StatefulWidget {
  final String doctorId;
  final String appointmentId;
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentStatus;

  AppointmentCard({
    required this.doctorId,
    required this.appointmentId,
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentStatus,
  });

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  String meetingId = '';

  @override
  void initState() {
    super.initState();

    fetchMeetingIdFromServer(widget.appointmentId).then((meetingId) {
      setState(() {
        this.meetingId = meetingId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(7),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doctor: ${widget.doctorName}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${widget.appointmentDate}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Time: ${widget.appointmentTime}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: widget.appointmentStatus != 'pending'
                      ? Colors.green
                      : Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  'Status: ${widget.appointmentStatus}',
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.appointmentStatus != 'pending'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            widget.appointmentStatus == 'confirmed' && meetingId.isNotEmpty
                ? ElevatedButton(
              onPressed: () {
                // Navigate to the JoinScreen and pass the meeting ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        JoinScreen(meetingId: meetingId),
                  ),
                );
              },
              child: Text('Join'),
            )
                : widget.appointmentStatus == 'accepted'
                ? ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentGateway(
                      amount: 2500,
                      doctorId: widget.doctorId,
                      appointmentId: widget.appointmentId,
                    ),
                  ),
                );
              },
              child: Text('Pay'),
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<String> fetchMeetingIdFromServer(String appointmentId) async {
    final Uri uri = Uri.parse('http://localhost/ayuravedaapp/patientappoinment.php/meet/$appointmentId');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final  data = json.decode(response.body);
        return data; // Adjust this based on your server response structure
      } else {
        throw Exception('Failed to load meeting ID');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server: $error');
    }
  }
}

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  List<AppointmentCard > appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointmentsFromServer();
  }

  Future<void> fetchAppointmentsFromServer() async {
    final prefs = await SharedPreferences.getInstance();
    final String? patientId = prefs.getString('patient_id');

    if (patientId == null) {
      return;
    }
    print(patientId);

    final url = Uri.parse('http://localhost/ayuravedaapp/patientappoinment.php/appoinmentShow/'+patientId);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> responseJson = jsonDecode(response.body);


        List<dynamic> appointmentsData = responseJson['appointments'] ?? [];

        if (appointmentsData.isNotEmpty) {
          // Create a list of AppointmentCard widgets
          List<AppointmentCard> appointmentCards = appointmentsData.map((appointment) {
            final firstname = appointment['firstname'] ?? '';
            final lastname = appointment['lastname'] ?? '';

            return AppointmentCard(
              doctorId:appointment['doctor_id'],
              appointmentId:appointment['appoinment_id'],
              doctorName: '$firstname $lastname',
              appointmentDate: appointment['appoinment_date_time'].toString().substring(0, 10), // Extract date part
              appointmentTime: appointment['appoinment_date_time'].toString().substring(11, 16), // Extract time part
              appointmentStatus: appointment['appoinment_status'],
            );
          }).toList();

          setState(() {
            appointments = appointmentCards;
          });
        } else {
          // Handle the case where 'appointments' is empty or null
          // You can set appointments to an empty list or display a message to the user.
          setState(() {
            appointments = [];
          });
        }




      } else {
        throw Exception('Failed to load data from the server');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Appointment Details'),
          backgroundColor:  Color(0xFF0F3446),
        ),
        body: ListView(
          children: appointments.map((appointment) {
            return AppointmentCard(
              doctorId:appointment.doctorId,
              appointmentId: appointment.appointmentId,
              doctorName: appointment.doctorName,
              appointmentDate: appointment.appointmentDate,
              appointmentTime: appointment.appointmentTime,
              appointmentStatus: appointment.appointmentStatus,
            );
          }).toList(),
        ),
      ),
    );
  }
}
//
// class AppointmentData {
//   final String doctorId;
//   final String appointmentId;
//   final String doctorName;
//   final String appointmentDate;
//   final String appointmentTime;
//   final String appointmentStatus;
//
//   AppointmentData({
//     required this.doctorId,
//     required this.appointmentId,
//     required this.doctorName,
//     required this.appointmentDate,
//     required this.appointmentTime,
//     required this.appointmentStatus,
//   });
//
//   factory AppointmentData.fromJson(Map<String, dynamic> json) {
//     return AppointmentData(
//       doctorId:json['doctor_id'] ,
//       appointmentId: json['appoinment_id'],
//
//       doctorName: json['doctorName'],
//       appointmentDate: json['appointmentDate'],
//       appointmentTime: json['appointmentTime'],
//       appointmentStatus: json['appointmentStatus'],
//     );
//   }
// }



