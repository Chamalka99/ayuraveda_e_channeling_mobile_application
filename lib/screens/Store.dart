import 'dart:convert';
import 'package:ayuraveda_e_channeling/screens/product_category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



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
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'හෙළ සුව',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
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
              title: Text('My orders '),
              onTap: () {
                // Perform action
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


  Product({required this.id, required this.name, required this.imageUrl, required this.price,required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['product_name'],
      imageUrl: json['product_image'],
      price: json['product_price'],
      description:json['product_description'],
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
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Row( // Change Column to Row
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the top of the row
        children: [
          // Move Image.asset to the left side
          Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              "assets/images/P1.png",
              height: 150,
              width: 150, // Specify a fixed width for the image
              fit: BoxFit.cover,
            ),
          ),
          Expanded( // Use Expanded to make the content take up the remaining space
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                children: [
                  Text(
                  product.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Price: ' + product.price,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                    // TODO: Add the product to the cart with the selected quantity
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
      ),
      body: ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = favoriteProducts[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Price: ${product.price}'),
            // Add other product details or actions here...
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



















































