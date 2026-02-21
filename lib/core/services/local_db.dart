import 'package:hive_flutter/hive_flutter.dart';

class LocalDb {
  static final LocalDb _instance = LocalDb.internal();

  LocalDb.internal();

  factory LocalDb() => _instance;

  Box get userBox => Hive.box('User');
  Box get appBox => Hive.box('App');

  init() async {
    await Hive.initFlutter();
    await Future.wait([Hive.openBox('User'), Hive.openBox('App')]);
  }

  clear() {
    Hive.box('User').clear();
    Hive.box('App').clear();
  }
}
