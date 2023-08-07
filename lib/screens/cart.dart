

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
              ListView.builder(
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
                        String productName =productData['product_name'];
                        double productPrice =double.parse( productData['product_price']);

                        return ListTile(
                          title: Text(productName),
                          subtitle: Text('Quantity: ${cartItem.quantity.toString()}'),
                          trailing: Text('Price: ${productPrice * cartItem.quantity}'),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
