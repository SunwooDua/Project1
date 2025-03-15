import 'package:flutter/material.dart';

class RecipeScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;

  RecipeScreen({required this.recipe}); //constructor for recipe

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
        ), // need to use widget to access recipe in widget RecipeScreen
        backgroundColor: Colors.green,
      ),
      body: Column(),
    );
  }
}
