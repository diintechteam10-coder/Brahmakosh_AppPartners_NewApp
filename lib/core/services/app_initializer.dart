import 'package:brahmakoshpartners/core/services/current_user.dart';
import 'package:brahmakoshpartners/core/services/local_db.dart';
import 'package:brahmakoshpartners/core/globals/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

class AppInitializer {
  static Future<void> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase (Critical for app function)
      try {
        await Firebase.initializeApp();
        logger.i("Firebase Initialized Successfully");
      } catch (e) {
        logger.e("Firebase Initialization Failed: $e");
      }

      // Initialize Local DB (Critical)
      await LocalDb().init();

      // Initialize Current User (Critical)
      await CurrentUser().init();

      logger.i("App Initialized Successfully");
    } catch (e) {
      logger.e("Initialization Failed: $e");
    }
  }
}
