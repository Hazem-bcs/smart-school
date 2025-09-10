
class Constants {
  static String baseUrl = 'https://d4341e103222.ngrok-free.app'; // Default fallback URL

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
  // Teacher profile
  static String teacherProfileEndpoint = '/api/teacher_profile';
  static String updateTeacherProfileEndpoint = '/api/update_teacher_profile';
  // Student profile
  static String updateStudentProfileEndpoint = '/api/update_student_profile';
  // Quizzes
  static String getAllQuiz = '/api/show_quizz_section';
  static String getOneQuiz = '/api/showquizz';
  // Attendance
  static String getAttendanceDetailsEndpoint = '/api/attendance-summary';
  static String getAttendanceSummaryEndpoint = '';
  // Schedule
  static String getScheduleForDateEndpoint = '/api/teacher_schedule';
  static String getStudentScheduleForDateEndpoint = '/api/student_schedule';
    // Assignments
  static String submitAssignmentEndpoint = '/api/submit_assignment';
  static String getAllClasses = '/api/teacher_classes';
   // zoom
   static String createZoomMeetingsEndpoint = '/api/create_teacher_meeting';
   static String getZoomMeetingsEndpoint = '/api/get_teacher_meeting';
  // assginment
  static String createAssignmentEndpoint = '/api/create_assignment';
  static String getAllAssignmentsEndpoint = '/api/get_assignment_teacher';
  static String gradeAssignmentByIdEndpoint = '/api/grade_Submission';
  static String markAssignmentAsGradedEndpoint = '/api/completed_assignment';
  static String getSubmitAssignmentByIdEndpoint = '/api/get_assignment_submit';
  // assginment student
  static String getStudentAssignmentsEndpoint = '/api/get_assignment';
  static String submitStudentAssignmentEndpoint = '/api/submit_assignment';

  // student zoom 
  static String getStudentZoom = '/api/get_zoom_student';

}
