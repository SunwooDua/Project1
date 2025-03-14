import 'package:flutter/material.dart';
import 'package:project1/recipe.dart';

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
  // main screen
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MainScreen"), backgroundColor: Colors.blue),
      body: Column(
        children: [
          GestureDetector(
            child: ListTile(
              // list of recipe
              leading: Icon(Icons.food_bank),
              title: Text('Recipe Title'),
              trailing: Icon(Icons.list),
            ),
            onTap: () {
              // tap to transition to Recipe Screen
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RecipeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
