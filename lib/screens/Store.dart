import 'dart:convert';
import 'package:ayuraveda_e_channeling/screens/product_category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'my_orders.dart';



class MyComponent extends StatefulWidget {
  @override
  _MyComponentState createState() => _MyComponentState();
}

class _MyComponentState extends State<MyComponent> {
  List<Product> products = [];
  List<Product> filteredProducts = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost/ayuravedaapp/products.php/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        products = List<Product>.from(data.map((item) => Product.fromJson(item)));
        filteredProducts = products;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) => product.name.toLowerCase().contains(query.toLowerCase())).toList();
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
        title: Text('Product List'),
        backgroundColor:  Color(0xFF0F3446),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0F3446),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'හෙළ සුව',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(height: 8), // Add some space between the app name and the quote
                  Text(
                    '"Connecting you to health experts, one tap at a time."',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17, // You can adjust the font size as needed
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Product Category'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductCategoryFormApp(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Favourite'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteForm(),
                  ),
                );
              },
            ),

            ListTile(
              title: Text('My Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdersApp(),
                  ),
                );
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
                filterProducts(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SingleProductView(product: product)),
                    );
                  },
                  child: ProductCard(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String price;
  final String description;
  final String stock;



  Product({required this.id, required this.name, required this.imageUrl, required this.price,required this.description,required this.stock});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['product_name'],
      imageUrl: json['product_image'],
      price: json['product_price'],
      description:json['product_description'],
        stock:json['product_stock'],
    );
  }
}
class CartItemView {
  final String id;
  final int quantity;

  CartItemView(this.id, this.quantity);

  // Convert CartItemView object to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
    };
  }

  // Create a CartItemView object from a Map retrieved from storage
  factory CartItemView.fromMap(Map<String, dynamic> map) {
    return CartItemView(
      map['id'],
      map['quantity'],
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFDDDFE5),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset(
                "assets/images/P1.png",
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    Text(
                      'Price: LKR ${product.price}', // Assuming price is a numeric value
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.blue, // Change text color if desired
                      ),
                    ),
                    Text(
                      'Stock: ${product.stock}', // Assuming stock is a numeric value
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.green, // Change text color if desired
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class SingleProductView extends StatefulWidget {
  final Product product;

  SingleProductView({required this.product});


  @override
  _SingleProductViewState createState() => _SingleProductViewState();

}




class _SingleProductViewState extends State<SingleProductView> {
  bool isFavorite = false; // Flag to track whether the product is a favorite
  List<CartItemView> cartItems = [];

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite; // Toggle the favorite status
    });

    if (isFavorite) {
      // Add the product to the favorite list when it's marked as a favorite
      favoriteProducts.add(widget.product);
    } else {
      // Remove the product from the favorite list when it's unmarked as a favorite
      favoriteProducts.remove(widget.product);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoriteForm()),
    );
  }



  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void _showAddToCartDialog(BuildContext context) {
    int quantity = 1; // Initial quantity value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text('Add to Cart'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product: ${widget.product.name}'),
                  SizedBox(height: 10),
                  Text('Quantity: $quantity'),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cartItems.add(
                        new CartItemView(widget.product.id, quantity));
                    saveCart(cartItems);

                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static const String _kCartKey = 'cart_key';

  static Future<void> saveCart(List<CartItemView> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> cartList = cartItems.map((item) =>
        item.toMap()).toList();
    await prefs.setString(_kCartKey, jsonEncode(cartList));
  }

  // Retrieve the list of CartItemView from local storage
  void loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String cartString = prefs.getString(_kCartKey) ?? '';
    print(cartString);
    if (cartString.isEmpty) {
      cartItems = [];
      return;
    }

    final List<dynamic> cartList = jsonDecode(cartString);
    cartItems = cartList.map((item) => CartItemView.fromMap(item)).toList();
  }


  void showAddToCartSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Product added to cart successfully!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor:  Color(0xFF0F3446),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        // Add left and right padding
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/P1.png",
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Price Rs: ' + widget.product.price,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        backgroundColor: Color(0xFF0F3446),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Add to cart',
                          style: TextStyle(fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () {
                        _showAddToCartDialog(context);
                        //
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: toggleFavorite,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class FavoriteForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products'),
        backgroundColor:  Color(0xFF0F3446),
      ),
      body: ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return Card(
            elevation: 3, // Add elevation for a card-like effect
            margin: EdgeInsets.all(8), // Add margin for spacing
            child: ListTile(
              title: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Make the text bold
                  fontSize: 18, // Increase font size
                ),
              ),
              subtitle: Text(
                'Price: ${product.price}',
                style: TextStyle(
                  color: Colors.black, // Change the text color to grey
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.favorite, // You can use your favorite icon here
                  color: Colors.red, // Customize the color as needed
                ),
                onPressed: () {
                  // Toggle the favorite status of the product
                  ;
                },
              ),
              // Add other product details or actions here...
            ),
          );
        },
      ),
    );
  }


}

void main() {
  runApp(MaterialApp(
    title: 'Ayuraveda App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MyComponent(),
  ));
}

// Create a list to store favorite products
List<Product> favoriteProducts = [];



















































