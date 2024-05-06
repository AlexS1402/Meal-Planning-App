import 'package:flutter/material.dart';
import 'package:mealplanningapp/models/recipe_model.dart';
import 'package:mealplanningapp/services/api/api_service.dart';
import 'package:mealplanningapp/views/add_recipe_screen.dart';
import 'package:mealplanningapp/views/recipe_details.dart';
import 'package:mealplanningapp/services/user_service.dart';

class RecipeSearch extends StatefulWidget {
  const RecipeSearch({Key? key}) : super(key: key);

  @override
  _RecipeSearchState createState() => _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {
  final TextEditingController _searchController = TextEditingController();
  late List<Recipe> recipes = [];
  bool isLoading = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  void loadRecipes() async {
    setState(() {
      isLoading = true;
    });
    try {
      int userId = await UserService
          .getUserId(); // Ensure you get the user ID correctly.
      recipes = await ApiService().fetchRecipes(
          userId); // Modify the fetchRecipes method to accept a userId parameter.
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(e.toString());
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void searchRecipes(String query, {int page = 1}) async {
    setState(() {
      isLoading = true;
      currentPage = page; // Update currentPage state here
    });
    try {
      int userId = await UserService.getUserId();
      recipes = await ApiService().searchRecipes(query, page, userId: userId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddRecipeScreen()));
            },
          )
        ],
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
                searchRecipes(value);
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(recipes[index].title),
                        subtitle: Text(
                          'Calories: ${recipes[index].calories.toString()}, Proteins: ${recipes[index].proteins.toString()}g, '
                          'Carbs: ${recipes[index].carbs.toString()}g, Fats: ${recipes[index].fats.toString()}g',
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipeDetailsScreen(
                                      recipe: recipes[index])));
                        },
                      );
                    },
                  ),
          ),
          // Pagination controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (currentPage > 1) {
                    searchRecipes(_searchController.text,
                        page: currentPage - 1);
                  }
                },
              ),
              Text('Page $currentPage'),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  searchRecipes(_searchController.text, page: currentPage + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
