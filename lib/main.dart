import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:invigilator_app/core/theme/theme.dart';
import 'package:invigilator_app/core/utils/dimensions.dart';
import 'package:invigilator_app/l10n/getx_localization.dart';
import 'core/utils/app_routes.dart';
import 'core/utils/app_version.dart';
import 'core/utils/dependencies.dart' as dep;
import 'core/utils/pref_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await dep.init();
  initializeGet();
  runApp(const MyApp());
}

Future<void> initializeGet() async {
  await Get.putAsync(() async {
    return Dimensions(); // Initialize Dimensions class
  });
  await PrefHelper.init();
  await AppVersion.getVersion();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return GetMaterialApp(
      title: 'Invigilator app',
      debugShowCheckedModeBanner: false,
      //localization
      translations: Language(),
      locale: (PrefHelper.getLanguage() == 1)
          ? const Locale('en', 'US')
          : const Locale('bn', 'BD'),
      // themeMode: ThemeMode.system,
      theme: FAppTheme.lightTheme,
      //darkTheme: FAppTheme.darkTheme,
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes.routes,
    );
  }
}
