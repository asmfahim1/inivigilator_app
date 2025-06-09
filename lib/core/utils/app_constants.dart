class AppConstants {

  static String get baseUrl => "http://192.168.0.105:8000/v1/";
  //static String get baseUrl => 'http://localhost:8000/v1/';
  //static String get baseUrl => 'http://restapi.adequateshop.com/api/';

  static String loginUrl = "teachers/login";
  static String getExamIdWiseRoomList = "teachers/room/students/";
  static String getAllExams  = "exams/all";
  static String getRoomWiseStudentListStudentByRoom  = "https://grypas.inflack.xyz/grypas-api/api/v1/employee/trained";
  static String getFaceVectors  = "teachers/students";
  static String uploadPresentStudentData  = "teachers/attendance";
  static String uploadProxyStudentsData  = "teachers/proxy/student";
  static String fileUpload = 'image/upload';

  //Password
  static const String storedPassword = "password";

  //Admin
  static const String storedUserId = "user_id";
  static const String storedAdminNum = "admin_num";
}