import 'package:get/get.dart';
import 'package:invigilator_app/module/home/view/list_of_students_screen.dart';
import 'package:invigilator_app/module/home/view/present_student_list.dart';
import 'package:invigilator_app/module/home/view/recognition_screen.dart';
import '../../module/auth/login/view/get_started_screen.dart';
import '../../module/auth/login/view/login_screen.dart';
import '../../module/auth/login/view/splash_screen.dart';
import '../../module/home/view/home_screen.dart';

class AppRoutes {
  static const splashScreen = '/splash_screen';
  static const getStartedScreen = '/get_started_screen';

  //Auth
  static const loginScreen = '/login_screen';
  static const registrationPage = '/registration_screen';

  static const homeScreen = '/home_screen';

  static const studentInfoScreen = '/student_info_screen';
  static const recognitionScreen = '/recognition_screen';
  static const attendanceListScreen = '/attendance_list_screen';

  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      transition: Transition.cupertino,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: getStartedScreen,
      transition: Transition.cupertino,
      page: () => const GetStartedScreen(),
    ),
    GetPage(
      name: loginScreen,
      transition: Transition.noTransition,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: homeScreen,
      transition: Transition.noTransition,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: studentInfoScreen,
      transition: Transition.noTransition,
      page: () {
        final int examId = Get.arguments['examId'];
        final int roomId = Get.arguments['roomId'];
        return StudentsInfo(
          examId: examId,
          roomId: roomId,
        );
      },
    ),
    GetPage(
      name: recognitionScreen,
      transition: Transition.noTransition,
      page: () => RecognitionScreen(),
    ),
    GetPage(
      name: attendanceListScreen,
      transition: Transition.noTransition,
      page: () => AttendanceListScreen(),
    ),
  ];
}
