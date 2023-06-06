import 'package:flutter/material.dart';

class Article {
  final String title;
  final String author;
  final String postedOn;
  final String imageUrl;

  Article({
    required this.title,
    required this.author,
    required this.postedOn,
    required this.imageUrl,
  });
}

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  final List<Article> _articles = [
    Article(
      title: 'Dr. Anjali Asok',
      author: 'Specilist Gynecological Disorders',
      postedOn: '6 Years experience',
      imageUrl: 'https://img.freepik.com/free-vector/doctor-character-background_1270-84.jpg?w=740&t=st=1686080815~exp=1686081415~hmac=6f775fcb955d2b8c2c1013d98b58638f34c32c3f8dc0ec96f97a7beb8c116b96',
    ),
    Article(
      title: 'Dr. Srishankar. A',
      author: 'Specilist Gynecological Disorders',
      postedOn: '12 Years experience',
      imageUrl: 'https://img.freepik.com/free-vector/doctor-character-background_1270-84.jpg?w=740&t=st=1686080815~exp=1686081415~hmac=6f775fcb955d2b8c2c1013d98b58638f34c32c3f8dc0ec96f97a7beb8c116b96',
    ),
    Article(
      title: 'Dr. Srishankar. A',
      author: 'Specilist Gynecological Disorders',
      postedOn: '8 Years experience',
      imageUrl: 'https://img.freepik.com/free-vector/doctor-character-background_1270-84.jpg?w=740&t=st=1686080815~exp=1686081415~hmac=6f775fcb955d2b8c2c1013d98b58638f34c32c3f8dc0ec96f97a7beb8c116b96',
    ),
    Article(
      title: 'Dr. Srishankar. A',
      author: 'Specilist Gynecological Disorders',
      postedOn: '5 Years experience',
      imageUrl: 'https://img.freepik.com/free-vector/doctor-character-background_1270-84.jpg?w=740&t=st=1686080815~exp=1686081415~hmac=6f775fcb955d2b8c2c1013d98b58638f34c32c3f8dc0ec96f97a7beb8c116b96',
    ),
    // Add more articles here
  ];

  List<Article> _filteredArticles = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _filteredArticles = _articles;
    super.initState();
  }

  void _filterArticles(String query) {
    setState(() {
      _filteredArticles = _articles
          .where((article) =>
      article.title.toLowerCase().contains(query.toLowerCase()) ||
          article.author.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterArticles,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[500]),
                        onPressed: () {
                          _searchController.clear();
                          _filterArticles('');
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
          Expanded(
            child: ListView.builder(
              itemCount: _filteredArticles.length,
              itemBuilder: (BuildContext context, int index) {
                final item = _filteredArticles[index];
                return Container(
                  height: 136,
                  margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${item.author} · ${item.postedOn}",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.star,
                                      size: 16),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.star, size: 16),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.star, size: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(item.imageUrl),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

