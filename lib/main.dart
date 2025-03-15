import 'package:flutter/material.dart';
import 'package:project1/recipe.dart';
import 'recipedata.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecipeApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Map<String, dynamic>> filteredRecipes = recipes;
  bool isVegan = false;
  bool isVegetarian = false;
  bool isGlutenFree = false;

  void _applyFilters() {
    setState(() {
      filteredRecipes =
          recipes.where((recipe) {
            if (isVegan && recipe['vegan'] != true) return false;
            if (isVegetarian && recipe['vegetarian'] != true) return false;
            if (isGlutenFree && recipe['glutenFree'] != true) return false;
            return true;
          }).toList();
    });
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Filter Recipes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: Text("Vegan"),
                    value: isVegan,
                    onChanged: (value) {
                      setSheetState(() => isVegan = value!);
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Vegetarian"),
                    value: isVegetarian,
                    onChanged: (value) {
                      setSheetState(() => isVegetarian = value!);
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Gluten-Free"),
                    value: isGlutenFree,
                    onChanged: (value) {
                      setSheetState(() => isGlutenFree = value!);
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _applyFilters();
                    },
                    child: Text(
                      "Apply Filters",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MainScreen"), backgroundColor: Colors.blue),
      body: ListView.builder(
        itemCount: filteredRecipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.food_bank),
            title: Text(filteredRecipes[index]['name']),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => RecipeScreen(recipe: filteredRecipes[index]),
                ),
              );
            },
            trailing: Icon(Icons.list),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showFilterOptions,
        label: Text("Filter Recipes"),
        icon: Icon(Icons.filter_list),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
