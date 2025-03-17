import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // refer to database helper from icollege
  static Database? _db;
  //singleton instance
  static final DatabaseHelper instance = DatabaseHelper._constructor();

  final String table = 'recipe_table';
  final String columnId = '_id';
  final String columnName = 'name';
  final String columnIngredients = 'ingredients';
  final String columnInstructions = 'instruction';
  final String columnTypes = 'type';
  final String columImages = 'image';

  // NEW: Add meal plan table
  final String mealPlanTable = 'meal_plan_table';

  // create private constructor for Database
  DatabaseHelper._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!; // if not null return db
    _db = await getDatabase(); //else get database (open)
    return _db!;
  }

  //set up database
  Future<Database> getDatabase() async {
    //where will be database?
    final databaseCreatePath = await getDatabasesPath();
    final databasePath = join(databaseCreatePath, "recipe_db.db");
    final database = await openDatabase(
      // actual function and logic for database
      databasePath,
      version: 2, // Increase version to trigger onUpgrade
      onCreate: (db, version) {
        // Create recipe table
        db.execute('''
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY, 
          $columnName TEXT NOT NULL,
          $columnIngredients TEXT,
          $columnInstructions TEXT,
          $columnTypes TEXT,
          $columImages TEXT
        )
        ''');

        // NEW: Create meal plan table
        db.execute('''
        CREATE TABLE $mealPlanTable (
          $columnId INTEGER PRIMARY KEY, 
          $columnName TEXT NOT NULL,
          $columnIngredients TEXT,
          $columnInstructions TEXT,
          $columnTypes TEXT,
          $columImages TEXT
        )
        ''');

        print('Tables created successfully'); // debug
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // If upgrading from version 1 to 2, create the meal plan table
        if (oldVersion == 1 && newVersion == 2) {
          try {
            // Check if table already exists before creating
            var tables = await db.rawQuery(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='$mealPlanTable'",
            );
            if (tables.isEmpty) {
              await db.execute('''
              CREATE TABLE $mealPlanTable (
                $columnId INTEGER PRIMARY KEY, 
                $columnName TEXT NOT NULL,
                $columnIngredients TEXT,
                $columnInstructions TEXT,
                $columnTypes TEXT,
                $columImages TEXT
              )
              ''');
              print('Meal plan table created during upgrade');
            }
          } catch (e) {
            print('Error upgrading database: $e');
          }
        }
      },
    );
    return database;
  }

  // functions to save recipes for offline use
  Future<int> saveRecipe(Map<String, dynamic> recipe) async {
    Database db = await database; //getting database instance

    // insert database into table
    return await db.insert(
      table,
      recipe,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // functions to get recipes for offline use
  Future<List<Map<String, dynamic>>> getSavedRecipe() async {
    Database db = await database; //getting database instance

    // Fetch recipes from the database
    List<Map<String, dynamic>> recipes = await db.query(table);

    // insert database into table
    return recipes;
  }

  // NEW: Add recipe to meal plan
  Future<int> addToMealPlan(Map<String, dynamic> recipe) async {
    try {
      Database db = await database;

      // Check if recipe already exists in meal plan
      List<Map<String, dynamic>> existingRecipes = await db.query(
        mealPlanTable,
        where: '$columnName = ?',
        whereArgs: [recipe['name']],
      );

      if (existingRecipes.isNotEmpty) {
        // Recipe already in meal plan, no action needed
        return 0;
      }

      // Make sure we have a clean copy of the recipe map
      Map<String, dynamic> cleanRecipe = {
        columnName: recipe['name'],
        columnIngredients: recipe['ingredients'],
        columnInstructions: recipe['instruction'],
        columnTypes: recipe['type'],
        columImages: recipe['image'],
      };

      // Add recipe to meal plan
      return await db.insert(
        mealPlanTable,
        cleanRecipe,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error adding to meal plan: $e');
      return -1;
    }
  }

  // NEW: Get all recipes in meal plan
  Future<List<Map<String, dynamic>>> getMealPlanRecipes() async {
    try {
      Database db = await database;

      // Check if table exists
      var tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$mealPlanTable'",
      );
      if (tables.isEmpty) {
        // Table doesn't exist yet, create it
        await db.execute('''
        CREATE TABLE IF NOT EXISTS $mealPlanTable (
          $columnId INTEGER PRIMARY KEY, 
          $columnName TEXT NOT NULL,
          $columnIngredients TEXT,
          $columnInstructions TEXT,
          $columnTypes TEXT,
          $columImages TEXT
        )
        ''');
        return [];
      }

      return await db.query(mealPlanTable);
    } catch (e) {
      print('Error getting meal plan recipes: $e');
      return [];
    }
  }

  // NEW: Remove recipe from meal plan
  Future<int> removeFromMealPlan(String recipeName) async {
    try {
      Database db = await database;
      return await db.delete(
        mealPlanTable,
        where: '$columnName = ?',
        whereArgs: [recipeName],
      );
    } catch (e) {
      print('Error removing from meal plan: $e');
      return -1;
    }
  }
}
