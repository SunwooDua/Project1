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
    'instruction':
        'prepare rice (steam), prepare fried eggs, prepare spoon of soy sauce and ssame oil, mix them all and enjoy!',
    'type': 'vegan & gluten-free',
  },
];
