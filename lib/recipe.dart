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
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch, // make sure there is no blank space on width
        children: [
          Expanded(
            flex: 5, // ratio of each part
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                image: DecorationImage(
                  image: AssetImage(widget.recipe['image']),
                  fit:
                      BoxFit
                          .fitHeight, // stretch it to fit the containers height
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1, // one this to be smallest
            child: Container(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text('Type : ${widget.recipe['type']}'),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(color: Colors.yellow),
              child: Text('Ingredients : \n ${widget.recipe['ingredients']}'),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(color: Colors.lightGreen),
              child: Text('Instructions : \n ${widget.recipe['instruction']}'),
            ),
          ),
        ],
      ),
    );
  }
}
