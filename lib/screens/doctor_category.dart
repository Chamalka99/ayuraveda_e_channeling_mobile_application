import 'package:flutter/material.dart';

void main() {
  runApp(DoctorConsultationApp());
}

class DoctorConsultationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Consultation',
      theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.green,
      ),
      home: CategoriesScreen(),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  final List<Category> categories = [
    Category('Cardiologist', 'assets/cardiologist.png'),
    Category('Dermatologist', 'assets/dermatologist.png'),
    Category('Pediatrician', 'assets/pediatrician.png'),
    Category('Orthopedic', 'assets/orthopedic.png'),
    Category('Cardiologist', 'assets/cardiologist.png'),
    Category('Dermatologist', 'assets/dermatologist.png'),
    Category('Pediatrician', 'assets/pediatrician.png'),
    Category('Orthopedic', 'assets/orthopedic.png')
    // Add more categories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Categories'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(category: categories[index]);
        },
      ),
    );
  }
}

class Category {
  final String name;
  final String imagePath;

  Category(this.name, this.imagePath);
}

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          // Handle category selection, e.g., navigate to a list of doctors in that category
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              category.imagePath,
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

