import 'package:flutter/material.dart';

void main() {
  runApp(ProductCategoryFormApp());
}

class ProductCategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;

  ProductCategoryCard({
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            imageUrl,
            height: 150.0, // Adjust the height as needed
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16.0,
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

class ProductCategoryFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Product Categories'),
        ),
        body: ListView(
          children: [
            ProductCategoryCard(
              title: 'Herbal Drinks',
              imageUrl:
              'https://static.oxinis.com/healthmug/image/blog/article/4-banner-700.jpg', // Replace with your image URL
              description:
              'Herbal blends have been used as energy drinks, digestive support, and sleep tonics for thousands of years. Most commonly, the powder of the plant—from the root, stem, fruit, or leaves—is what ancient practitioners used in these preparations.',
            ),
            ProductCategoryCard(
              title: 'Herbal Tea',
              imageUrl: 'https://roshnisanghvi.com/cdn/shop/articles/Brown_Beige_Simple_Modern_Minimalist_Daily_Vlog_YouTube_Thumbnail_1200x675.png?v=1675833967', // Replace with your image URL
              description: 'Ayurvedic teas are traditional herbal teas served in ayurvedic medicines. Ayurvedic teas are of three types- Vatha tea, Pitha tea, and Kapha tea. These teas are made with different herbs and elements and are meant to detoxify and purify the body. This is the key component of Ayurveda to attain health and wellness.',
            ),
            ProductCategoryCard(
              title: 'Herbal Cosmetics',
              imageUrl:
              'https://vivecosmetic.com/wp-content/uploads/2023/01/herbal-shampoo-1-1200x675.jpg', // Replace with your image URL
              description:
              'Herbal cosmetics are formulated, using different cosmetic ingredients to form the base in which one or more herbal ingredients are used to cure various skin ailments. All human being have urge to look beautiful. It is because of this reason that they have been using different types of materials from time immemorial.',
            ),
            ProductCategoryCard(
              title: 'Body Oils',
              imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQYLBBBW8G9XwScTmIhi5-u6DvmUYfzwz_2tQ&usqp=CAU', // Replace with your image URL
              description: 'Ayurvedic massage oils are obtained from plants and contains no harmful chemicals or artificial preservatives. The primary purpose of these oils is to nourish the body externally and from within. The significance of Abhyanga oil goes a long way back and is deep-rooted in different cultures worldwide.',
            ),
            // Add more ProductCategoryCard widgets for other categories
          ],
        ),
      ),
    );
  }
}
