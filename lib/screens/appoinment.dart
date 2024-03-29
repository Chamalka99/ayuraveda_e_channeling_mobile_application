import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorConsultationForm extends StatefulWidget {
  final int id;

  DoctorConsultationForm({required this.id});

  @override
  _DoctorConsultationFormState createState() => _DoctorConsultationFormState();
}

class _DoctorConsultationFormState extends State<DoctorConsultationForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedAppoinmentDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _symptomsController = TextEditingController();

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectApoinmentDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedAppoinmentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedAppoinmentDate) {
      setState(() {
        _selectedAppoinmentDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Appointment Form'),
        backgroundColor:  Color(0xFF0F3446),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Patient Name'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Patient Email'),
            ),
            TextFormField(
              controller: _mobileController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${_selectedDate.toLocal()}".split(' ')[0],
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: _selectApoinmentDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Appoinment date',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${_selectedAppoinmentDate.toLocal()}".split(' ')[0],
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: _selectTime,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Appointment Time',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("${_selectedTime.format(context)}"),
                    Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _symptomsController,
              maxLines: 5,
              decoration: InputDecoration(labelText: 'Symptoms'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    String apiUrl = 'http://localhost/ayuravedaapp/patientappoinment.php/appoinment'; // Replace with your PHP script URL
    final prefs = await SharedPreferences.getInstance();
    final String? patientId = prefs.getString('patient_id');

    if (patientId == null) {
      return;
    }
    print(patientId);
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> formData = {
      'patient_id':patientId,
      'patient_name': _nameController.text,
      'patient_email': _emailController.text,
      'patient_mobile_number': _mobileController.text,
      'patient_bdy': _selectedDate.toString(),
      'appoinment_date': _selectedAppoinmentDate.toString(),
      'appoinment_date_time': _selectedTime.format(context),
      'symptoms': _symptomsController.text,
      'doctor_id': widget.id.toString()// Pass the doctor's ID here
    };

    // Convert formData to a JSON string
    final jsonData = json.encode(formData);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful submission, handle accordingly
        print(response.body);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Form submitted successfully!',
          autoCloseDuration: const Duration(seconds: 2),
        );
      } else {
        // Handle errors
        print('Failed to submit form');
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Failed to submit form.',
          autoCloseDuration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'An error occurred: $e',
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  }
}
