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

  // create private constructor for Database
  DatabaseHelper._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!; // if not nul return db
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
      version: 1,
      onCreate: (db, version) {
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
        print('Table created successfully'); // debug
      },
    );
    return database;
  }

  // functions to save recipes for offline use
  Future<int> saveRecipe(Map<String, dynamic> recipe) async {
    Database db =
        await DatabaseHelper.instance.database; //getting database instance

    // insert database into table
    return await db.insert(
      DatabaseHelper.instance.table,
      recipe,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // functions to get recipes for offline use
  Future<List<Map<String, dynamic>>> getSavedRecipe() async {
    Database db =
        await DatabaseHelper.instance.database; //getting database instance

    // Fetch recipes from the database
    List<Map<String, dynamic>> recipes = await db.query(table);

    // insert database into table
    return recipes;
  }
}
