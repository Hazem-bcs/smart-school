import 'dart:convert';
import 'package:dio/dio.dart';

class Constants {
  static String baseUrl = 'https://03a4dfe57407.ngrok-free.app'; // Default fallback URL
  
  // Initialize constants - call this in main before running the app
  static Future<void> init() async {
    await fetchBaseUrl();
  }
  
  // Temporary method to fetch baseUrl from GitHub
  static Future<void> fetchBaseUrl() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://raw.githubusercontent.com/Hazem-bcs/smart-school/main/config.json');
      if (response.statusCode == 200) {
        // Handle both string and Map responses
        Map<String, dynamic> data;
        if (response.data is String) {
          // Parse string response as JSON
          data = jsonDecode(response.data);
        } else if (response.data is Map<String, dynamic>) {
          data = response.data;
        } else {
          print('Unexpected response format: ${response.data.runtimeType}');
          return;
        }
        
        if (data.containsKey('baseUrl')) {
          baseUrl = data['baseUrl'];
          print('BaseUrl updated to: $baseUrl');
        }
      }
    } catch (e) {
      // Keep default URL if fetch fails
      print('Failed to fetch baseUrl: $e');
      print('Using default baseUrl: $baseUrl');
    }
  }

  static String loginEndpoint = '/api/login';
  static String logoutEndpoint = '/api/logout';
  static String getDuesEndpoint = '/api/showinvoices';
  static String getHomeWorkListEndpoint = '/auth/login';
  static String getSubjectEndpoint = '/auth/login';
  static String getSubjectListEndpoint = '/auth/login';
  static String getTeacherById = '/api/show_teacher';
  static String getTeacherList = '/api/show_teacher_section';
  static String getStudentProfiel = '/api/show_student_profile';
}
