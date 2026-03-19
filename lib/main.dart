import 'package:brahmakoshpartners/core/bindings/global_bindings.dart';
import 'package:brahmakoshpartners/core/routes/app_pages.dart';
import 'package:brahmakoshpartners/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:brahmakoshpartners/core/services/app_initializer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:brahmakoshpartners/features/call/listeners/global_call_listener.dart';
import 'package:brahmakoshpartners/features/chat/listeners/global_notification_listener.dart';

import 'package:brahmakoshpartners/core/connectivity/bloc/connectivity_bloc.dart';
import 'package:brahmakoshpartners/core/connectivity/service/connectivity_service.dart';
import 'package:brahmakoshpartners/core/connectivity/widget/connectivity_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // ✅ Web me bhi safe

  // ✅ apne boxes yahan open karo (example)
  await Hive.openBox('tokens');
  await Hive.openBox('currentUser');

  await AppInitializer.init();

  runApp(
    RepositoryProvider(
      create: (context) => ConnectivityService(),
      child: BlocProvider(
        create: (context) => ConnectivityBloc(context.read<ConnectivityService>()),
        child: const BrahmakoshPartners(),
      ),
    ),
  );
}

class BrahmakoshPartners extends StatelessWidget {
  const BrahmakoshPartners({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return GlobalCallListener(
          child: GetMaterialApp(
            builder: (context, child) {
              return ConnectivityOverlay(
                child: GlobalNotificationListener(child: child!),
              );
            },
            initialBinding: GlobalBindings(),
            initialRoute: AppPages.splashScreen,
            getPages: AppRoutes.routes,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
