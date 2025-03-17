import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// list containig recipes
List<Map<String, dynamic>> recipes = [
  // used dynamics incase any other than string is needed
  {
    'name': 'Soy-sauce Egg Rice',
    'ingredients':
        'Soy Sauce (2Tbsp or more), Eggs (usually 2), Rice (1 bowl), Sesame Oil (1Tbsp or more)',
    'instruction': // i want to display step in new line. will be using replace thus instead of , used &
        '1) prepare rice (steam) & 2) prepare fried eggs & 3) prepare spoon of soy sauce and sessame oil & 4) mix them all and enjoy!',
    'type':
        'vegetarian', // need to be string in order to be used in sql database
    'image': 'assets/soy.jpg',
  },
  {
    'name': 'Gochujang Egg Rice',
    'ingredients':
        'Gochujang (2Tbsp or more), Eggs (usually 2), Rice (1 bowl), Sesame Oil (1Tbsp or more)',
    'instruction':
        '1) prepare rice (steam) & 2) prepare fried eggs & 3) prepare spoon of gochujang sauce and sessame oil & 4) mix them all and enjoy!',
    'type':
        'vegetarian', // need to be string in order to be used in sql database
    'image': 'assets/gochujang.jpg',
  },
  {
    'name': 'Korean Style Corn Cheese',
    'ingredients':
        'drainned canned corn, buter (tbsp), sugar (1 tbsp), mayonnaise (3 tbsp), shredded mozarella cheese',
    'instruction':
        '1) drain canned corn & heat skillet with butter & 2) mix corn, sugar, and mayonnaise and spread them on heated skillet & 3) on top, spread mozarella chesse and wait for cheese to melt and enjoy!',
    'type':
        'gluten-free', // need to be string in order to be used in sql database
    'image': 'assets/corncheese.jpg',
  },
];
