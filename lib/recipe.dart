import 'package:flutter/material.dart';
import 'package:sqflite/utils/utils.dart';
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
        backgroundColor: Colors.lime,
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
              decoration: BoxDecoration(
                color: Color(0xFFd5f0a8),
              ), //0x = #, FF = 100 opacity, color code
              child: FittedBox(
                // adjuest font size automatically to fit the container
                alignment:
                    Alignment.topLeft, // make sure it starts from top left
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Type : ${widget.recipe['type']}'),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(color: Color(0xFFede8c7)),
              child: FittedBox(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Ingredients : \n ${widget.recipe['ingredients'].replaceAll(',', '\n')}',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(color: Color(0xFFd698c1)),
              child: FittedBox(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Instructions : \n ${widget.recipe['instruction'].replaceAll('&', '\n')}', // replace & with \n so every step is in new line
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
