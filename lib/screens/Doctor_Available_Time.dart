import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import sqflite_ffi
import 'package:path/path.dart';

void main() {
  sqfliteFfiInit(); // Initialize sqflite_ffi
  runApp(DoctorAvailabilityApp());
}

class DoctorAvailabilityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Availability',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Map<String, dynamic>>> availabilityData;

  @override
  void initState() {
    super.initState();
    availabilityData = getDoctorAvailability();
  }

  Future<List<Map<String, dynamic>>> getDoctorAvailability() async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'ayuravedaapp.db'), // Specify the database file with ".db" extension
    );

    final List<Map<String, dynamic>> data =
    await database.query('doctor_availability');

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Availability'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: availabilityData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final data = snapshot.data;
            return ListView.builder(
              itemCount: data?.length ?? 0,
              itemBuilder: (context, index) {
                final slot = data![index];
                return ListTile(
                  title: Text('Slot ID: ${slot['slot_id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${slot['date']}'),
                      Text('Start Time: ${slot['start_time']}'),
                      Text('End Time: ${slot['end_time']}'),
                      Text('Doctor ID: ${slot['doc_id']}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
