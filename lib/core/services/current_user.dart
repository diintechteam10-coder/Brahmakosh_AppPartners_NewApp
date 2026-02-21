import 'package:brahmakoshpartners/core/globals/logger.dart';
import 'package:brahmakoshpartners/core/services/local_db.dart';

class CurrentUser {
  static final CurrentUser _instance = CurrentUser.internal();

  CurrentUser.internal();

  factory CurrentUser() => _instance;

  Map userDetails = {};

  get userName => userDetails['profile']?['name'];
  get profilePicture => userDetails['profileImage'];

  init() async {
    userDetails = await LocalDb().userBox.get('details') ?? {};
    logger.d(userDetails);
  }

  save(Map data) {
    userDetails = data;
    LocalDb().userBox.put('details', data);
  }

  clear() {
    userDetails.clear();
  }

  getStep() {
    int step = 0;

    if (userDetails['emailVerified'] ?? false == true) {
      step = 1;
    }

    if (userDetails['mobileVerified'] ?? false == true) {
      step = 2;
    }

    if (userDetails['registrationStep'] == 3) {
      step = 3;
    }

    return step;
  }
}
