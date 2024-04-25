import 'package:flutter/material.dart';

class RecipeSearch extends StatefulWidget {
  @override
  _RecipeSearchState createState() => _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search for Recipies'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search recipes',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (String value) {
                // Placeholder for search functionality
                print('Search for $value');
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Placeholder for number of search results
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Recipe ${index + 1}'),
                  subtitle: Text('Recipe details here...'),
                  onTap: () {
                    // Placeholder for selecting a recipe
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
