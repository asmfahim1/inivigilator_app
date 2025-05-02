enum AppConstantKey {
  USER_ID,
  USER_INFO,
  REGISTRATION,
  TOKEN,
  LANGUAGE,
  YYYY_MM_DD,
  DD_MM_YYYY,
  DD_MM_YYYY_SLASH,
  D_MMM_Y_HM,
  D_MMM_Y,
  D_MM_Y,
  YYYY_MM,
  MMM,
  MMMM,
  MMMM_Y,
  APPLICATION_JSON,
  BEARER,
  MULTIPART_FORM_DATA,
  IS_SWITCHED,
  DEVICE_ID,
  DEVICE_OS,
  USER_AGENT,
  APP_VERSION,
  BUILD_NUMBER,
  ANDROID,
  IOS,
  IPN_URL,
  STORE_ID,
  STORE_PASSWORD,
  MOBILE,
  EMAIL,
  PUSH_ID,
  EN,
  BN,
  FONTFAMILY,
}

extension AppConstantExtention on AppConstantKey {
  String get key {
    switch (this) {
      case AppConstantKey.USER_ID:
        return "USER_ID";
      case AppConstantKey.USER_INFO:
        return "USER_INFO";
      case AppConstantKey.REGISTRATION:
        return "REGISTRATION";
      case AppConstantKey.TOKEN:
        return "TOKEN";
      case AppConstantKey.LANGUAGE:
        return "language";
      case AppConstantKey.DD_MM_YYYY:
        return "dd-MM-yyyy";
      case AppConstantKey.DD_MM_YYYY_SLASH:
        return "dd/MM/yyyy hh:mm a";
      case AppConstantKey.D_MMM_Y_HM:
        return "d MMMM y hh:mm a";
      case AppConstantKey.D_MM_Y:
        return "d MMM y";
      case AppConstantKey.D_MMM_Y:
        return "d MMMM y";
      case AppConstantKey.MMMM_Y:
        return "MMMM y";
      case AppConstantKey.MMM:
        return "MMM";
      case AppConstantKey.MMM:
        return "MMMM";
      case AppConstantKey.YYYY_MM:
        return 'yyyy-MM';
      case AppConstantKey.YYYY_MM_DD:
        return "yyyy-MM-dd";
      case AppConstantKey.APPLICATION_JSON:
        return "application/json";
      case AppConstantKey.BEARER:
        return "Bearer";
      case AppConstantKey.MULTIPART_FORM_DATA:
        return "multipart/form-data";
      case AppConstantKey.IS_SWITCHED:
        return "IS_SWITCHED";
      case AppConstantKey.USER_AGENT:
        return "user-agent";
      case AppConstantKey.BUILD_NUMBER:
        return "build";
      case AppConstantKey.DEVICE_ID:
        return "device-id";
      case AppConstantKey.APP_VERSION:
        return "app-version";
      case AppConstantKey.DEVICE_OS:
        return "device-os";
      case AppConstantKey.PUSH_ID:
        return "push-id";
      case AppConstantKey.ANDROID:
        return "android";
      case AppConstantKey.IOS:
        return "ios";
      case AppConstantKey.IPN_URL:
        return "ipn_url";
      case AppConstantKey.STORE_ID:
        return "store_id";
      case AppConstantKey.STORE_PASSWORD:
        return "store_password";
      case AppConstantKey.MOBILE:
        return "mobile";
      case AppConstantKey.EMAIL:
        return "email";
      case AppConstantKey.EN:
        return 'en';
      case AppConstantKey.BN:
        return 'bn';
      case AppConstantKey.FONTFAMILY:
        return 'Arboria';

      default:
        return "";
    }
  }
}
