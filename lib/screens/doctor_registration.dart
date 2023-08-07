import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorRegistrationForm extends StatefulWidget {
  @override
  _DoctorRegistrationFormState createState() => _DoctorRegistrationFormState();
}

class _DoctorRegistrationFormState extends State<DoctorRegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Prepare the data to be sent
      Map<String, dynamic> data = {
        'firstname': firstnameController.text,
        'lastname': lastnameController.text,
        'email': emailController.text,
        'telephone': telephoneController.text,
        'category': categoryController.text,
        'qualification': qualificationController.text,
        'age': ageController.text,
        'password': passwordController.text,
      };

      String apiUrl = 'http://localhost/ayuravedaapp/doctorregistration.php';

      // Send the data to the PHP API
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          // Parse the response
          dynamic responseData = json.decode(response.body);
          if (responseData['status'] == true) {
            print(responseData['msg']);
          } else {
            print('Error: ${responseData['msg']}');
          }
        } else {
          // Error occurred
          print('Error: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isPasswordVisible = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: firstnameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your First name';
                  }
                  return null;
                },
              ),
              // Add more form fields for other input fields
              TextFormField(
                controller: lastnameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              // Add more form fields for other input fields
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: telephoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Doctor Category'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a doctor category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: qualificationController,
                decoration: InputDecoration(labelText: 'Education Qualification'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the education qualification';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Doctor Age'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter doctor age';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                obscureText: !_isPasswordVisible,
              ),



              ElevatedButton(
                child: Text('Register'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DoctorRegistrationForm(),
  ));
}
