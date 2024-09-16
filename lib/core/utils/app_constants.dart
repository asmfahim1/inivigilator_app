class AppConstants {

  static String get baseUrl => 'http://192.168.0.108:8000/v1/';
  //static String get baseUrl => 'http://localhost:8000/v1/';
  //static String get baseUrl => 'http://restapi.adequateshop.com/api/';

  static String loginUrl = 'teacher/login';
  static String getStudentsByRoom = 'room/students/?roomNo=204&hall_address=du&date=20/2/2024';
  static String getAllExams  = 'exams/all';
  static String getStudentByRoom  = 'https://grypas.inflack.xyz/grypas-api/api/v1/employee/trained';
  static String getFaceVectors  = 'teachers/students';

  //Password
  static const String storedPassword = 'password';

  //Admin
  static const String storedUserId = 'user_id';
  static const String storedAdminNum = 'admin_num';
}