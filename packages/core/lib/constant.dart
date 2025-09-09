
class Constants {
  static String baseUrl = 'https://7499646fc491.ngrok-free.app'; // Default fallback URL

  static String loginEndpoint = '/api/login';
  static String logoutEndpoint = '/api/logout';
  static String getDuesEndpoint = '/api/showinvoices';
  static String getHomeWorkListEndpoint = '/api/homeworks';
  static String getSubjectEndpoint = '/api/show_one_subject';
  static String getSubjectListEndpoint = '/api/show_subjects';
  static String getTeacherById = '/api/show_teacher';
  static String getTeacherList = '/api/show_teacher_section';
  static String getStudentProfiel = '/api/show_student_profile';
  static String getAllSubjects = '/api/show_subjects';
  static String getOneSubject = '/api/show_one_subject';
  // Quizzes
  static String getAllQuiz = '/api/show_quizz_section';
  static String getOneQuiz = '/api/showquizz';
  // Attendance
  static String getAttendanceDetailsEndpoint = '/api/attendance-summary';
  static String getAttendanceSummaryEndpoint = '';
  // Schedule
  static String getScheduleForDateEndpoint = '/api/teacher_schedule';
}
