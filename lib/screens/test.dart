import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataPreview extends StatefulWidget {
  @override
  _DataPreviewState createState() => _DataPreviewState();
}

class _DataPreviewState extends State<DataPreview> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/ayuraveda/create.php'));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Preview'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('ID: ${data[index]['id']}'),
            subtitle: Text('Email: ${data[index]['email']}'),
          );
        },
      ),
    );
  }
}
