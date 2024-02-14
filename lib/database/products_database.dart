import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ProductsDatabase {
  static final NAMEBD = 'DESPENSADB';
  static final VERSIONDB = 1;
  static Database? _database;
  get database {
    if (_database != null) return _database;
    return _database = _initDatabase();
  }

  _initDatabase() async{
    Directory folder = await getApplicationDocumentsDirectory();
  }
}
