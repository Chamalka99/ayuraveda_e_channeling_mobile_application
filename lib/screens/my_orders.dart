import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(OrdersApp());
}

class OrdersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Order List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrderListScreen(),
    );
  }
}

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when the widget is initialized
  }

  Future<void> fetchOrders() async {

      final prefs = await SharedPreferences.getInstance();
      final String? patientId = prefs.getString('patient_id');

      if (patientId == null) {
        return;
      }
      print(patientId);
      Map<String, dynamic> requestData = {
        "patient_id":patientId
      };

      final response = await http.post(Uri.parse('http://localhost/ayuravedaapp/orders.php/view'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData));


    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        orders = jsonData.map((item) => Order(
          item['order_id'],
          item['order_date'],
          double.parse(item['order_amount']),
          item['order_status'],

        )).toList();
      });
    } else {
      throw Exception('Failed to load orders from the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      body: orders.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return OrderCard(
            order: orders[index],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(order: orders[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Order {
  final String referenceID;
  final String orderDateTime;
  final double orderAmount;
  final String orderStatus;


  Order(this.referenceID, this.orderDateTime, this.orderAmount, this.orderStatus );
}

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  OrderCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust margins
      elevation: 4, // Add elevation for a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Round the corners
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0), // Padding inside the ListTile
        title: Text(
          'Reference ID: HS#20230923${order.referenceID}',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue, // Customize text color
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Date: ${order.orderDateTime}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black, // Customize text color
              ),
            ),
            Text(
              'Order Amount: LKR ${order.orderAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Customize text color
              ),
            ),
            Text(
              'Order Status: ${order.orderStatus}',
              style: TextStyle(
                fontSize: 14.0,
                color: order.orderStatus == 'Pending'
                    ? Colors.orange // Customize text color based on status
                    : Colors.green,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // Customize button color
            onPrimary: Colors.white, // Customize text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Round the button
            ),
          ),
          child: Text(
            'View',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

}

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  OrderDetailScreen({required this.order});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List<OrderItems> orderItems = [];

  @override
  void initState() {
    super.initState();
    fetchOrderItems(); // Fetch order items when the widget is initialized
  }

  Future<void> fetchOrderItems() async {
    // Make an API request to get order items by order ID
    final response = await http.post(
      Uri.parse('http://localhost/ayuravedaapp/orders.php/viewitems'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"order_id": widget.order.referenceID}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        orderItems = jsonData.map((item) => OrderItems(
          item['order_id'],
          item['product_id'],
          item['quantity'],
          double.parse(item['unit_price']),
          double.parse(item['total_price']),
          item['product_name'],
        )).toList();
      });
    } else {
      throw Exception('Failed to load order items from the server');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reference ID: ${widget.order.referenceID}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,// Set text color to black
              ),
            ),
            Text(
              'Order Date: ${widget.order.orderDateTime}',
              style: TextStyle(
                color: Colors.black, // Set text color to black
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
            Text(
              'Order Amount: LKR ${widget.order.orderAmount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.red, // Set text color to black
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
            Text(
              'Order Status: ${widget.order.orderStatus}',
              style: TextStyle(
                color: Colors.black, // Set text color to black
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
            SizedBox(height: 25.0), // Add some spacing

            Text(
              'Order Items:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Set text color to black

              ),
            ),

            // Display the list of order items
            orderItems.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
              children: orderItems.map((orderItem) {
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'Product Name: ${orderItem.productName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        fontFamily: 'YourCustomFont', // Replace with your custom font
                        color: Colors.black, // Customize text color

                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.0),
                        Text(
                          'Quantity: ${orderItem.quantity}',
                          style: TextStyle(
                            fontFamily: 'YourCustomFont', // Replace with your custom font
                            color: Colors.blue,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Unit Price: LKR ${orderItem.unitPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'YourCustomFont', // Replace with your custom font
                            color: Colors.green,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Total Price: LKR ${orderItem.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'YourCustomFont', // Replace with your custom font
                            color: Colors.red,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              }).toList(),
            ),
          ],
        ),
      ),
    );
  }


}

class OrderItems {
  final String orderID;
  final String productID;
  final String quantity; // Assuming quantity is an integer
  final double unitPrice;
  final double totalPrice;
  final String productName;

  OrderItems(
    this.orderID,
     this.productID,
     this.quantity,
     this.unitPrice,
     this.totalPrice,
     this.productName
  );

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      json['order_id'],
       json['product_id'],
        json['quantity'],
       double.parse(json['unit_price']),
       double.parse(json['total_price']),
       json['product_name']
    );
  }
}


