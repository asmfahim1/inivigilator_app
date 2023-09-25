import 'package:invigilator_app/core/utils/extensions.dart';
import 'package:invigilator_app/core/utils/pref_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../constant/constant_key.dart';

class AppVersion {
  static String currentVersion = "";
  static String versionCode = "";
  static Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
    versionCode = packageInfo.buildNumber;
    await PrefHelper.setString(AppConstant.APP_VERSION.key, currentVersion);
    await PrefHelper.setString(AppConstant.BUILD_NUMBER.key, versionCode);
    "Current version is  ${currentVersion.toString()}".log();
    "App version Code is  ${versionCode.toString()}".log();
  }
}


