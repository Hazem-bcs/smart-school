import 'package:dio/dio.dart';
import '../../data/models/zoom_meeting_model.dart';

abstract class ZoomMeetingsRemoteDataSource {
  Future<List<ZoomMeetingModel>> getAllZoomMeetings();
}

class ZoomMeetingsRemoteDataSourceImpl implements ZoomMeetingsRemoteDataSource {
  final Dio dio;

  ZoomMeetingsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ZoomMeetingModel>> getAllZoomMeetings() async {
    // const String apiUrl = '';
    try {
      await Future.delayed(const Duration(seconds: 1));

      final List<Map<String, dynamic>> dummyJsonList = [
        {
          'id': 'dummy1',
          'topic': 'Dummy Chapter 1: Calculus Basics',
          'className': 'Mathematics',
          'teacher': 'Mr. Dummy Teacher',
          'dateTime':
              DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
          'zoomLink': 'https://zoom.us/dummy/1',
          'isLive': true,
        },
        {
          'id': 'dummy2',
          'topic': 'Dummy Introduction to Data Structures',
          'className': 'Computer Science',
          'teacher': 'Ms. Dummy Code',
          'dateTime':
              DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          'zoomLink': 'https://zoom.us/dummy/2',
          'isLive': false,
        },
        {
          'id': 'dummy3',
          'topic': 'Dummy History of Ancient Egypt',
          'className': 'History',
          'teacher': 'Prof. Dummy Scholar',
          'dateTime':
              DateTime.now()
                  .add(const Duration(days: 2, hours: 3))
                  .toIso8601String(),
          'zoomLink': 'https://zoom.us/dummy/3',
          'isLive': false,
        },
        {
          'id': 'dummy4',
          'topic': 'Dummy Physics Fundamentals',
          'className': 'Physics',
          'teacher': 'Dr. Dummy Einstein',
          'dateTime':
              DateTime.now()
                  .subtract(const Duration(hours: 2))
                  .toIso8601String(), // Past meeting
          'zoomLink': 'https://zoom.us/dummy/4',
          'isLive': false,
        },
      ];

      // Convert dummy JSON to ZoomMeetingModel list
      return dummyJsonList
          .map((json) => ZoomMeetingModel.fromJson(json))
          .toList();
      // --- End of Dummy Data Section ---

      /*
      // --- Original API Call (Commented out) ---
      final response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList
            .map((json) => ZoomMeetingModel.fromJson(json))
            .toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to load Zoom meetings: ${response.statusCode}',
        );
      }
      */
    } on DioException catch (e) {
      // Keep error handling for other potential issues (e.g., if somehow accessed with real API)
      throw DioException(
        requestOptions: e.requestOptions,
        error:
            e.error ??
            'Failed to connect to the server (dummy data should prevent this in most cases)',
        type: e.type,
      );
    }
  }
}
