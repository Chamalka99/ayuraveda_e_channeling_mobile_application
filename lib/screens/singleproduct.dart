import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class SingleProduct extends StatefulWidget {
  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  List<Product> products = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/ayuravedaapp/products.php/singleproduct/2'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = List<Product>.from(data.map((item) => Product.fromJson(item)));
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
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetails(product: product),
                ),
              );
            },
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;
  final String price;
  // Add more properties as needed

  Product({required this.name, required this.imageUrl,required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['product_name'],
        imageUrl: json['product_image'],
        price: json['product_price']
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

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
                  product.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Price: '+ product.price,
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

class ProductDetails extends StatelessWidget {
  final Product product;

  ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              product.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              product.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Price: '+ product.price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
