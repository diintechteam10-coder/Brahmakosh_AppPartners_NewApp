import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:brahmakoshpartners/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // 1. Initialize Hive with a temporary path
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);

    // 2. Open boxes required by LocalDb and main
    // Using explicit names found in codebase
    await Hive.openBox('User');
    await Hive.openBox('App');
    await Hive.openBox('tokens');
    await Hive.openBox('currentUser');

    // 3. Mock Secure Storage
    FlutterSecureStorage.setMockInitialValues({});
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BrahmakoshPartners());

    // Verify that the app builds.
    expect(find.byType(BrahmakoshPartners), findsOneWidget);
  });
}
