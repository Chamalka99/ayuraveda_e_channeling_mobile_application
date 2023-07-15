import 'dart:convert';
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
          final doctorinfor = doctorinformation[index];
          return DoctorInf(doctorinfor:doctorinfor);
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
      child: Column(
        children: [
          Image.asset(
            "assets/images/P1.png",
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
