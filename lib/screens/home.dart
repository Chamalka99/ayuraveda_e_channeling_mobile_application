import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();


    return Scaffold(
      backgroundColor: const Color(0xFFE9EDF5), // Set the background color
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, top:40), // Set the left margin
              child: Row(
                children: [
                  SizedBox(width: 10), // Add some space between the text and the avatar
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/logo.png'),
                    backgroundColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'ආයුබෝවන් ! හෙළ සුව',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[500]),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Find Doctors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
               
              ],
            ),
          ],
        ),
      ),
    );
  }

  ProfileScreen() {}

}
