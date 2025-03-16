import 'package:flutter/material.dart';
import 'recipedata.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class RecipeScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeScreen({
    super.key,
    required this.recipe,
  }); //constructor for recipe

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipe['name'],
        ), // use widget to get recipe from RecipeScreen above
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [Image(image: AssetImage(widget.recipe['image']))],
      ),
    );
  }
}
