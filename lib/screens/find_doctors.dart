import 'dart:convert';
import 'package:ayuraveda_e_channeling/screens/appoinment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Doctor_Available_Time.dart';
import 'appoinment_view.dart';




class YourWidget extends StatefulWidget {
  @override
  _MyComponentState createState() => _MyComponentState();
}

class _MyComponentState extends State<YourWidget> {
  List<Doctorlist> doctorinformation = [];
  List<Doctorlist> filteredDoctorInformation = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/ayuravedaapp/doctorinformation.php/doctorinformation'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        doctorinformation = List<Doctorlist>.from(data.map((item) => Doctorlist.fromJson(item)));
        filteredDoctorInformation = doctorinformation; // Initialize filtered list
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }
  void filterDoctors(String query) {
    setState(() {
      filteredDoctorInformation = doctorinformation.where((doctor) {
        return doctor.name.toLowerCase().contains(query.toLowerCase()) ||
            doctor.specialities.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Doctors'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'හෙළ සුව',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: Text(
                'Doctor Category',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Perform action
              },
            ),
            ListTile(
              leading: const Icon(Icons.approval_rounded),
              title: Text(
                'My Appoinment',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Appointment(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: Text(
                'Report',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // Perform action
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                filterDoctors(value);
              },
              decoration: InputDecoration(
                hintText: 'Search for doctors...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDoctorInformation.length,
              itemBuilder: (context, index) {
                final doctorInfo = filteredDoctorInformation[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetailsScreen(doctorInfo: doctorInfo),
                      ),
                    );
                  },
                  child: DoctorInf(doctorinfor: doctorInfo),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Doctorlist {
  final int id;
  final String name;
  final String specialities;

  // Add more properties as needed

  Doctorlist({required this.id,required this.name, required this.specialities});

  factory Doctorlist.fromJson(Map<String, dynamic> json) {
    return Doctorlist(

        id: json['id'],
        name: json['name'],
        specialities: json['specialities'],


    );
  }
}

class DoctorInf extends StatelessWidget {
  final Doctorlist doctorinfor;

  DoctorInf({required this.doctorinfor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              "assets/images/E1.png",
              height: 125, // Adjust the height here
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorinfor.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    doctorinfor.specialities,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}



class DoctorDetailsScreen extends StatefulWidget {
  final Doctorlist doctorInfo;

  DoctorDetailsScreen({required this.doctorInfo});

  @override
  _DoctorDetailsScreenState createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  List<String> availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    fetchAvailableTimeSlots();
  }

  Future<void> fetchAvailableTimeSlots() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/ayuravedaapp/doctorinformation.php/doctor_availability'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List<dynamic>) {
          setState(() {
            availableTimeSlots = data.cast<String>();
          });
        }
      } else {
        print('Failed to fetch available time slots');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/E1.png",
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.doctorInfo.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Specialties: ${widget.doctorInfo.specialities}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (availableTimeSlots.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Available Time Slots:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        for (String timeSlot in availableTimeSlots)
                          Text(
                            timeSlot,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoctorAvailabilityApp()),
              );
            },
            child: Text('Doctor Available Time'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoctorConsultationFormApp()),
              );
            },
            child: Text('Appointment'),
          ),
        ],
      ),
    );
  }
}


