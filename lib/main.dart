import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project1/database_helper.dart';
import 'package:project1/recipe.dart';
import 'package:project1/meal_planner_screen.dart'; // Import the new screen
import 'recipedata.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // for desktop

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // if any desktop platform...
    sqfliteFfiInit(); // Initialize FFI for desktop platforms
    databaseFactory = databaseFactoryFfi;
  } else {
    databaseFactory = databaseFactory;
  }
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // do not show this banner
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
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> savedRecipes = []; // Store saved recipe
  List<Map<String, dynamic>> mealPlanRecipes = []; // Store meal plan recipes

  Set<String> favoriteRecipes = {}; // store favorite recipes by name

  List<Map<String, dynamic>> filteredRecipes = recipes;
  bool isVegan = false;
  bool isVegetarian = false;
  bool isGlutenFree = false;
  bool showFavoritesOnly = false; // Filter for favorites
  bool showSavedOnly = false; // Filter for saved recipes
  bool showMealPlanOnly = false; // NEW: Filter for meal plan recipes

  // upon initiazation, load saved recipe and meal plan recipes
  @override
  void initState() {
    super.initState();
    loadSavedRecipe();
    loadMealPlanRecipes();
  }

  // function to load recipe and convert into list to be fit in UI
  Future<void> loadSavedRecipe() async {
    List<Map<String, dynamic>> saved = await _databaseHelper.getSavedRecipe();
    setState(() {
      savedRecipes = saved;
    });
  }

  // NEW: Function to load meal plan recipes
  Future<void> loadMealPlanRecipes() async {
    List<Map<String, dynamic>> mealPlan =
        await _databaseHelper.getMealPlanRecipes();
    setState(() {
      mealPlanRecipes = mealPlan;
    });
  }

  // method to apply filters and update displayed recipe list
  void _applyFilters() {
    setState(() {
      filteredRecipes =
          recipes.where((recipe) {
            // check if type contains vegan, vegetarian, or gluten-free
            if (isVegan && !recipe['type']!.contains('vegan')) return false;
            if (isVegetarian && !recipe['type']!.contains('vegetarian'))
              return false;
            if (isGlutenFree && !recipe['type']!.contains('gluten-free'))
              return false;
            if (showFavoritesOnly && !favoriteRecipes.contains(recipe['name']))
              return false;
            if (showSavedOnly &&
                !savedRecipes.any(
                  (savedRecipe) => savedRecipe['name'] == recipe['name'],
                ))
              return false;
            // NEW: Filter for meal plan recipes
            if (showMealPlanOnly &&
                !mealPlanRecipes.any(
                  (mealPlanRecipe) => mealPlanRecipe['name'] == recipe['name'],
                ))
              return false;
            return true;
          }).toList();
    });
  }

  // method to toggle favorite status of a recipe
  void _toggleFavorite(String recipeName) {
    setState(() {
      if (favoriteRecipes.contains(recipeName)) {
        favoriteRecipes.remove(recipeName); // remove from favorites
      } else {
        favoriteRecipes.add(recipeName); // add to favorites
      }
    });
  }

  // NEW: Method to toggle meal plan status of a recipe
  void _toggleMealPlan(Map<String, dynamic> recipe) async {
    // Check if recipe is already in meal plan
    bool isInMealPlan = mealPlanRecipes.any(
      (mealPlanRecipe) => mealPlanRecipe['name'] == recipe['name'],
    );

    if (isInMealPlan) {
      // Remove from meal plan
      await _databaseHelper.removeFromMealPlan(recipe['name']);
    } else {
      // Add to meal plan
      await _databaseHelper.addToMealPlan(recipe);
    }

    // Reload meal plan recipes
    loadMealPlanRecipes();
  }

  // method to display filter options in a bottom modal sheet
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
                  CheckboxListTile(
                    title: Text("Show Favorites Only"),
                    value: showFavoritesOnly,
                    onChanged: (value) {
                      setSheetState(() => showFavoritesOnly = value!);
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Show Saved Only"),
                    value: showSavedOnly,
                    onChanged: (value) {
                      setSheetState(() => showSavedOnly = value!);
                    },
                  ),
                  // NEW: Meal Plan filter
                  CheckboxListTile(
                    title: Text("Show Meal Plan Only"),
                    value: showMealPlanOnly,
                    onChanged: (value) {
                      setSheetState(() => showMealPlanOnly = value!);
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
      appBar: AppBar(
        title: Text("MainScreen"),
        backgroundColor: Colors.blue,
        actions: [
          // Meal Planner button in app bar
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => MealPlannerScreen(),
                    ),
                  )
                  .then(
                    (_) => loadMealPlanRecipes(),
                  ); // Refresh after returning
            },
            tooltip: "Meal Planner",
          ),
        ],
      ),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min, // to make sure it wont overflow
              children: [
                // Favorite button
                IconButton(
                  onPressed: () {
                    _toggleFavorite(filteredRecipes[index]['name']);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color:
                        favoriteRecipes.contains(filteredRecipes[index]['name'])
                            ? Colors.red
                            : Colors
                                .grey, // if favorited, color is red else grey
                  ),
                ),
                // Meal planner button
                IconButton(
                  onPressed: () {
                    _toggleMealPlan(filteredRecipes[index]);
                  },
                  icon: Icon(
                    Icons.restaurant_menu,
                    color:
                        mealPlanRecipes.any(
                              (recipe) =>
                                  recipe['name'] ==
                                  filteredRecipes[index]['name'],
                            )
                            ? Colors
                                .orange // if in meal plan
                            : Colors.grey, // if not in meal plan
                  ),
                  tooltip: "Add to Meal Plan",
                ),
                // Save button
                IconButton(
                  onPressed: () async {
                    // recipe to save in database is filteredRecipes
                    Map<String, dynamic> recipeToSave = filteredRecipes[index];
                    await _databaseHelper.saveRecipe(recipeToSave);
                    loadSavedRecipe();
                  },
                  icon: Icon(
                    Icons.save,
                    color:
                        savedRecipes.any(
                              (recipe) =>
                                  recipe['name'] ==
                                  filteredRecipes[index]['name'],
                            )
                            ? Colors
                                .green // if saved
                            : Colors.grey, // if not saved
                  ),
                ),
              ],
            ),
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
