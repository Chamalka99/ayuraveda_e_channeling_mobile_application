

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartItemView {
  final String id;
  final int quantity;

  CartItemView(this.id, this.quantity);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }

  factory CartItemView.fromMap(Map<String, dynamic> map) {
    return CartItemView(
      map['id'],
      map['quantity'],
    );
  }
}

void  api_data_pass( List<CartItemView> cartItems)async{

    // Construct the JSON object for the request
    Map<String, dynamic> requestData = {
      'customer_id': 5,
      'product_quantities': {},
    };

    for (CartItemView cartItem in cartItems) {
      requestData['product_quantities'][cartItem.id] = [cartItem.id, cartItem.quantity];
    }

    // Send the checkout request
    try {

      print("called this 1");
      final response =await http.post(
        Uri.parse('http://localhost/ayuravedaapp/orders.php/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Checkout successful, handle the response as needed
        print('Checkout successful');
      } else {
        // Handle error response
        print('Checkout failed');
      }
    } catch (e) {
      print('Error during checkout: $e');
    }

}

class CartScreen extends StatefulWidget {
  List<CartItemView> cartItems = [];

  @override
  CartItemsScreen createState() => CartItemsScreen();
}

class CartItemsScreen extends State<CartScreen> {
  static const String _kCartKey = 'cart_key';

  static Future<void> saveCart(List<CartItemView> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> cartList = cartItems.map((item) => item.toMap()).toList();
    await prefs.setString(_kCartKey, jsonEncode(cartList));
  }

  Future<Map<String, dynamic>> fetchProductDetails(String productId) async {
    final url = 'http://localhost/ayuravedaapp/products.php/singleproduct/$productId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> productData = json.decode(response.body);
      return productData;
    } else {
      throw Exception('Failed to fetch product details');
    }
  }

  // Retrieve the list of CartItemView from local storage
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String cartString = prefs.getString(_kCartKey) ?? '';
    print(cartString);
    if (cartString.isEmpty) {
      setState(() {
        widget.cartItems = [];
      });
      return;
    }

    final List<dynamic> cartList = jsonDecode(cartString);
    setState(() {
      widget.cartItems = cartList.map((item) => CartItemView.fromMap(item)).toList();
    });
    print(widget.cartItems[0].id);
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  // Show a confirmation dialog and proceed with checkout if confirmed
  Future<void> _confirmAndCheckout() async {
    print('Entering _confirmAndCheckout()');
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Checkout'),
        content: Text('Are you sure you want to proceed with checkout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
       api_data_pass(widget.cartItems);

    }
  }

  @override
  Widget build(BuildContext context) {
    print("the length is  ${widget.cartItems.length}");
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              // Display cart items with product details
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    CartItemView cartItem = widget.cartItems[index];
                    return FutureBuilder<Map<String, dynamic>>(
                      future: fetchProductDetails(cartItem.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error fetching product details');
                        } else {
                          Map<String, dynamic> productData = snapshot.data!;
                          String productName = productData['product_name'];
                          double productPrice = double.parse(productData['product_price']);

                          return Container(
                            color: Colors.red, // Set the background color to red
                            child: Card(
                              child: ListTile(
                                title: Text(productName),
                                subtitle: Text('Quantity: ${cartItem.quantity.toString()}'),
                                trailing: Text('Price: ${productPrice * cartItem.quantity}'),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _confirmAndCheckout,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Set the background color
                  onPrimary: Colors.white, // Set the text color
                  elevation: 5, // Set the button's elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Set button's corner radius
                  ),
                  padding:EdgeInsets.symmetric(vertical:16,horizontal: 32), // Set padding
                ),
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 18, // Set text font size
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

}
