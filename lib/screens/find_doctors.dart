import 'dart:convert';
import 'package:ayuraveda_e_channeling/screens/appoinment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class YourWidget extends StatefulWidget {
  @override
  _MyComponentState createState() => _MyComponentState();
}

class _MyComponentState extends State<YourWidget> {
  List<Doctorlist> doctorinformation = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/ayuravedaapp/doctorinformation.php/doctorinformation'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        doctorinformation = List<Doctorlist>.from(data.map((item) => Doctorlist.fromJson(item)));
      });
    } else {
      throw Exception('Failed to fetch data');
    }
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
      body: ListView.builder(
        itemCount: doctorinformation.length,
        itemBuilder: (context, index) {
          final doctorInfo = doctorinformation[index];
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
    );
  }
}

class Doctorlist {
  final String name;
  final String specialities;
  final String experience;
  // Add more properties as needed

  Doctorlist({required this.name, required this.specialities,required this.experience});

  factory Doctorlist.fromJson(Map<String, dynamic> json) {
    return Doctorlist(
        name: json['doctor_name'],
        specialities: json['doctor_specialities'],
        experience: json['doctor_experience']
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
                    doctorinfor.experience,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
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




class DoctorDetailsScreen extends StatelessWidget {
  final Doctorlist doctorInfo;

  DoctorDetailsScreen({required this.doctorInfo});

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
                        color: Colors.black, // Change the color as needed
                        width: 2.0, // Set the desired width for the outline
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/E1.png", // Replace this with the image URL or local asset path
                        height: 200, // Set the desired height of the circular image
                        width: 200, // Set the desired width of the circular image
                        fit: BoxFit.cover, // Adjust the image's size to cover the entire area
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
                        doctorInfo.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Specialities: ${doctorInfo.specialities}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Experience: ${doctorInfo.experience}',
                        style: TextStyle(
                          fontSize: 18,
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
              // Add the functionality to book an appointment here
              // For example, you can navigate to the DoctorConsultationFormApp screen
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

