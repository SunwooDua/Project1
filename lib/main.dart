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
      debugShowCheckedModeBanner: false, // do not show this banner
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
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MainScreen"), backgroundColor: Colors.blue),
      body: GestureDetector(
        child: ListView.builder(
          itemCount: recipes.length, // number of recipes in recipe list
          itemBuilder: (context, index) {
            return ListTile(
              // list of recipe
              leading: Icon(Icons.food_bank),
              title: Text(
                recipes[index]['name'],
              ), // display name of recipe matching index
              // moved inside of ListTile since its now under List.View
              onTap: () {
                // tap to transition to Recipe Screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => RecipeScreen(
                          recipe: recipes[index],
                        ), // pass current index to recipe.dart),
                  ),
                );
              },
              trailing: IconButton(
                onPressed: () {
                  //change state of favorite based on press
                  setState(() {
                    if (favorite == true) {
                      favorite = false;
                    } else {
                      favorite = true;
                    }
                  });
                },
                icon: Icon(
                  Icons.favorite,
                  color:
                      favorite
                          ? Colors.red
                          : Colors
                              .grey, // if favorite is true, color is red else grey
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
