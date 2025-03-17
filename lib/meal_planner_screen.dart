import 'package:flutter/material.dart';
import 'package:project1/database_helper.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({Key? key}) : super(key: key);

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> mealPlanRecipes = [];
  Map<String, int> ingredientsList = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMealPlanRecipes();
  }

  Future<void> _loadMealPlanRecipes() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, dynamic>> mealPlan =
          await _databaseHelper.getMealPlanRecipes();

      if (mounted) {
        setState(() {
          mealPlanRecipes = mealPlan;
          _generateIngredientsList();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading meal plan recipes: $e');
      if (mounted) {
        setState(() {
          mealPlanRecipes = [];
          ingredientsList = {};
          isLoading = false;
        });
      }
    }
  }

  // Process all recipes and compile a list of ingredients
  void _generateIngredientsList() {
    ingredientsList = {};

    for (var recipe in mealPlanRecipes) {
      // Check if ingredients exist and are not empty
      if (recipe['ingredients'] != null &&
          recipe['ingredients'].toString().isNotEmpty) {
        // Split ingredients into a list
        List<String> ingredients = recipe['ingredients'].toString().split(',');

        // Process each ingredient
        for (var ingredient in ingredients) {
          String cleanIngredient = ingredient.trim();

          // Check if there's a quantity at the beginning (e.g., "2 cups flour")
          RegExp quantityRegex = RegExp(
            r'^(\d+(\.\d+)?\s*(g|kg|ml|l|cups?|tbsp|tsp)?\s+)',
          );
          var match = quantityRegex.firstMatch(cleanIngredient);

          String name;
          int quantity = 1;

          if (match != null) {
            // Extract quantity and name
            String quantityStr = match.group(0)!.trim();
            name = cleanIngredient.substring(match.end).trim();

            // Try to parse the quantity
            try {
              quantity = int.parse(
                quantityStr.replaceAll(RegExp(r'[^\d]'), ''),
              );
            } catch (e) {
              // Default to 1 if we can't parse
              quantity = 1;
            }
          } else {
            name = cleanIngredient;
          }

          // Add to or update ingredientsList
          if (ingredientsList.containsKey(name)) {
            ingredientsList[name] = ingredientsList[name]! + quantity;
          } else {
            ingredientsList[name] = quantity;
          }
        }
      }
    }
  }

  Future<void> _removeFromMealPlan(String recipeName) async {
    try {
      await _databaseHelper.removeFromMealPlan(recipeName);
      _loadMealPlanRecipes();
    } catch (e) {
      print('Error removing from meal plan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meal Planner"), backgroundColor: Colors.blue),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Recipes in meal plan
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Your Meal Plan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child:
                              mealPlanRecipes.isEmpty
                                  ? Center(
                                    child: Text(
                                      "No recipes in your meal plan yet.\nAdd recipes from the main screen.",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: mealPlanRecipes.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Icon(Icons.restaurant_menu),
                                        title: Text(
                                          mealPlanRecipes[index]['name'],
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            _removeFromMealPlan(
                                              mealPlanRecipes[index]['name'],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                        ),
                      ],
                    ),
                  ),

                  Divider(thickness: 1),

                  // Ingredients list
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Shopping List",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child:
                              ingredientsList.isEmpty
                                  ? Center(
                                    child: Text(
                                      "No ingredients to display.\nAdd recipes to your meal plan.",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                  : ListView.builder(
                                    itemCount: ingredientsList.length,
                                    itemBuilder: (context, index) {
                                      String ingredient = ingredientsList.keys
                                          .elementAt(index);
                                      int quantity =
                                          ingredientsList[ingredient]!;

                                      return ListTile(
                                        leading: Icon(Icons.shopping_basket),
                                        title: Text(ingredient),
                                        trailing: Text(
                                          quantity > 1 ? "$quantity" : "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
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
