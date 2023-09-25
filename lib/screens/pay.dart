import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';


class PaymentGateway extends StatefulWidget {
  int amount;
  String doctorId;
  String appointmentId;
  PaymentGateway({Key? key, required this.amount, required this.doctorId, required this.appointmentId}): super(key: key);
  @override
  _PaymentGatewayState createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  final _formKey = GlobalKey<FormState>();

  String cardNumber = '';
  String expirationDate = '';
  String cvv = '';
  String selectedCard = 'Visa';

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();
  Future<void> sendPaymentDetailsToServer() async {
    const url = 'http://localhost/ayuravedaapp/patientappoinment.php/pay'; // Replace with your actual API endpoint URL
    final prefs = await SharedPreferences.getInstance();
    final String? patientId = prefs.getString('patient_id');

    if (patientId == null) {
      return;
    }
    print(patientId);
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Adjust the content type as needed
      },
      body: json.encode({
        'patientId':patientId,
        'doctorId':widget.doctorId,
        'appointmentId':widget.appointmentId,
        'cardNumber': cardNumber, // Replace with your card details
        'expirationDate': expirationDate,
        'cvv': cvv,
        'selectedCard': selectedCard,
        'amount': widget.amount

      }),
    );

    if (response.statusCode == 200) {
      // Payment successful
      // You can handle the response from the server here
      print('Payment successful');
      print(response.body );
      showPaymentAmount();
    } else {
      // Payment failed, handle the error
      print('Payment failed: ${response.body}');
    }
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expirationDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Gateway'),
        backgroundColor: Color(0xFF0F3446),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.0),
              Text(
                'Hela Suwa Payment',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F3446),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Text(
                'Payment Amount: LKR '+ widget.amount.toString() ,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCard = 'Visa';
                          });
                        },
                        child: CreditCardIcon(
                          cardType: CardType.visa,
                          isSelected: selectedCard == 'Visa',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCard = 'Mastercard';
                          });
                        },
                        child: CreditCardIcon(
                          cardType: CardType.mastercard,
                          isSelected: selectedCard == 'Mastercard',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCard = 'americanexpress';
                          });
                        },
                        child: CreditCardIcon(
                          cardType: CardType.americanexpress,
                          isSelected: selectedCard == 'americanexpress',
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              PaymentTextField(
                label: 'Card Number',
                width: double.infinity,
                placeholder: 'XXXX XXXX XXXX XXXX',
                controller: cardNumberController,
                onSaved: (value) => cardNumber = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Card number is required';
                  }
                  if (value.length != 19) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PaymentTextField(
                    label: 'Expiration Date',
                    width: 150.0,
                    placeholder: 'MM/YY',
                    controller: expirationDateController,
                    onSaved: (value) => expirationDate = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Expiration date is required';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      ExpirationDateInputFormatter(),
                    ],
                  ),
                  PaymentTextField(
                    label: 'CVV',
                    width: 150.0,
                    placeholder: '123',
                    onSaved: (value) => cvv = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CVV is required';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    sendPaymentDetailsToServer();

                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20.0),
              if (cardNumber.isNotEmpty)
                Text(
                  'Payment Amount: LKR \100.00',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),

    );
  }

  void showPaymentAmount() {

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Payment Confirmation'),
          content: Text('Payment of Rs.2500 has been processed successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(), // Push HomeScreen
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

enum CardType { visa, mastercard, americanexpress }

class CreditCardIcon extends StatelessWidget {
  final CardType cardType;
  final bool isSelected;

  CreditCardIcon({required this.cardType, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    String assetName;
    if (cardType == CardType.visa) {
      assetName = 'assets/images/visa.svg';
    } else if (cardType == CardType.mastercard) {
      assetName = 'assets/images/mastercard.svg';
    } else if (cardType == CardType.americanexpress) {
      assetName = 'assets/images/americanexpress.svg';
    } else {
      assetName = ''; // Handle other cases or provide a default image path
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: isSelected ? Border.all(color: Colors.blue, width: 2.0) : null,
      ),
      child: assetName.endsWith('.svg') // Check if it's an SVG asset
          ? SvgPicture.asset(
        assetName,
        height: 60.0,
        width: 60.0,
      )
          : Image.asset(
        assetName,
        height: 60.0,
        width: 60.0,
      ),
    );
  }
}


class PaymentTextField extends StatelessWidget {
  final String label;
  final double width;
  final String? placeholder;
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  PaymentTextField({
    required this.label,
    this.width = 300.0,
    this.placeholder,
    this.controller,
    this.onSaved,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: validator,
        inputFormatters: inputFormatters,
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i > 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.length,
      ),
    );
  }
}

class ExpirationDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (text.length > 2 && !text.contains('/')) {
      text = text.substring(0, 2) + '/' + text.substring(2);
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(
        offset: text.length,
      ),
    );
  }
}
