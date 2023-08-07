import 'package:flutter/material.dart';


void main() {
  runApp(DoctorConsultationFormApp());
}

class DoctorConsultationFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Consultation Form',
      home: DoctorConsultationForm(),
    );
  }
}

class DoctorConsultationForm extends StatefulWidget {
  @override
  _DoctorConsultationFormState createState() => _DoctorConsultationFormState();
}

class _DoctorConsultationFormState extends State<DoctorConsultationForm> {
  TextEditingController _nameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _symptomsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Consultation Form'),
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
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Patient Email'),
            ),
            TextFormField(
              controller: _nameController,
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
              onPressed: () {
                // Handle form submission here
                _submitForm();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // Get the values from the controllers and process them
    String name = _nameController.text;
    String dob = "${_selectedDate.toLocal()}".split(' ')[0];
    String appointmentTime = "${_selectedTime.format(context)}";
    String symptoms = _symptomsController.text;

    // You can now send this data to a backend or perform any other action
    // For demonstration purposes, let's print the data for now.
    print('Patient Name: $name');
    print('Date of Birth: $dob');
    print('Appointment Time: $appointmentTime');
    print('Symptoms: $symptoms');
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}


