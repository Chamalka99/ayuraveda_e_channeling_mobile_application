import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(Appointment());
}

class Appointment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appointment App',
      home: AppointmentList(),
    );
  }
}

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    final response = await http.get(Uri.parse('http://localhost/ayuravedaapp/patientappoinment.php/appoinment'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data != null && data.containsKey('appoinment')) {
        final List<dynamic> appointments = data['appoinment'];

        return appointments.cast<Map<String, dynamic>>();
      } else {
        return []; // Return an empty list if 'appointments' key is missing
      }
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final appointments = snapshot.data;

            if (appointments == null || appointments.isEmpty) {
              return Center(
                child: Text('No appointments available.'),
              );
            }

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];

                if (appointment == null) {
                  return SizedBox.shrink(); // Skip null entries
                }

                return ListTile(
                  title: Text(appointment['patient_name'] ?? ''),
                  subtitle: Text(appointment['appoinment_date_time'] ?? ''),
                  // Add other appointment details here
                );
              },
            );
          }
        },
      ),
    );
  }
}

