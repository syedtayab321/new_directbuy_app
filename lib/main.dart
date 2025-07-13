import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:new_app_project/utils/common/controllers_initializations.dart';
import 'package:new_app_project/utils/routes/routes.dart';
import 'features/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DependencyInjection.init();

  runApp(
    DevicePreview(
      // enabled: false,
      enabled: !kReleaseMode,
      builder: (context) => ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DirectBuy',
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.splash,
            getPages: AppRoutes.routes,
            locale: DevicePreview.locale(context),
            builder: (context, child) {
              child = DevicePreview.appBuilder(context, child);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(1.0),
                ),
                child: child,
              );
            },
          );
        },
      ),
    ),
  );
}