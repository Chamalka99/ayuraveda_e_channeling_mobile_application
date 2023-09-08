import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(Appointment());
}

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentStatus;

  AppointmentCard({
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentStatus,
  });

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
              'Doctor: $doctorName',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Date: $appointmentDate',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Time: $appointmentTime',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: appointmentStatus == 'Confirmed'
                      ? Colors.green
                      : Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  'Status: $appointmentStatus',
                  style: TextStyle(
                    fontSize: 16,
                    color: appointmentStatus == 'Confirmed'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  List<AppointmentData> appointments = [];

  @override
  void initState() {
    super.initState();
    fetchAppointmentsFromServer();
  }

  Future<void> fetchAppointmentsFromServer() async {
    // Replace with your server URL
    final url = Uri.parse('http://localhost/ayuravedaapp/patientappoinment.php/appoinmentShow');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<AppointmentData> fetchedAppointments = data
            .map((item) => AppointmentData.fromJson(item))
            .toList();

        setState(() {
          appointments = fetchedAppointments;
        });
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
        ),
        body: ListView(
          children: appointments.map((appointment) {
            return AppointmentCard(
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

class AppointmentData {
  final String doctorName;
  final String appointmentDate;
  final String appointmentTime;
  final String appointmentStatus;

  AppointmentData({
    required this.doctorName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentStatus,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      doctorName: json['doctorName'],
      appointmentDate: json['appointmentDate'],
      appointmentTime: json['appointmentTime'],
      appointmentStatus: json['appointmentStatus'],
    );
  }
}



