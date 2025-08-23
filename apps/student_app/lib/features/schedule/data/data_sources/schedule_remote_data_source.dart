import '../models/schedule_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleModel>> getScheduleForDate(DateTime date);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  @override
  Future<List<ScheduleModel>> getScheduleForDate(DateTime date) async {
    print('🔍 ScheduleRemoteDataSource: Getting schedule for date: $date');
    await Future.delayed(const Duration(seconds: 1));

    // Check if it's weekend
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.friday) {
      print('🔍 ScheduleRemoteDataSource: Weekend detected, returning empty list');
      return [];
    }

    // Different schedules for different days
    List<Map<String, dynamic>> mockJsonList = [];
    
    switch (date.weekday) {
      case DateTime.monday:
        mockJsonList = [
          {
            "id": "1",
            "title": "الرياضيات",
            "description": "Advanced algebra and calculus",
            "startTime": DateTime(date.year, date.month, date.day, 9, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 10, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Mathematics",
            "teacherId": "teacher1",
            "location": "Room 101",
            "type": "classType",
            "status": "upcoming",
          },
          {
            "id": "2",
            "title": "العلوم",
            "description": "Physics and chemistry basics",
            "startTime": DateTime(date.year, date.month, date.day, 11, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 12, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Physics",
            "teacherId": "teacher2",
            "location": "Lab 2",
            "type": "classType",
            "status": "upcoming",
          },
          {
            "id": "3",
            "title": "اللغة الإنجليزية",
            "description": "English literature and grammar",
            "startTime": DateTime(date.year, date.month, date.day, 14, 30).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 16, 0).toIso8601String(),
            "className": "Grade 10A",
            "subject": "English",
            "teacherId": "teacher3",
            "location": "Room 203",
            "type": "classType",
            "status": "completed",
          },
        ];
        break;
        
      case DateTime.tuesday:
        mockJsonList = [
          {
            "id": "4",
            "title": "التاريخ",
            "description": "World history and civilizations",
            "startTime": DateTime(date.year, date.month, date.day, 9, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 10, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "History",
            "teacherId": "teacher4",
            "location": "Room 105",
            "type": "classType",
            "status": "upcoming",
          },
          {
            "id": "5",
            "title": "الجغرافيا",
            "description": "Physical and human geography",
            "startTime": DateTime(date.year, date.month, date.day, 11, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 12, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Geography",
            "teacherId": "teacher5",
            "location": "Room 106",
            "type": "classType",
            "status": "upcoming",
          },
          {
            "id": "6",
            "title": "الفنون",
            "description": "Art and design principles",
            "startTime": DateTime(date.year, date.month, date.day, 14, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 15, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Art",
            "teacherId": "teacher6",
            "location": "Art Studio",
            "type": "classType",
            "status": "upcoming",
          },
        ];
        break;
        
      case DateTime.wednesday:
        mockJsonList = [
          {
            "id": "7",
            "title": "الرياضيات",
            "description": "Geometry and trigonometry",
            "startTime": DateTime(date.year, date.month, date.day, 8, 30).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 10, 0).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Mathematics",
            "teacherId": "teacher1",
            "location": "Room 101",
            "type": "classType",
            "status": "completed",
          },
          {
            "id": "8",
            "title": "الفيزياء",
            "description": "Mechanics and dynamics",
            "startTime": DateTime(date.year, date.month, date.day, 10, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 11, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Physics",
            "teacherId": "teacher2",
            "location": "Lab 1",
            "type": "classType",
            "status": "upcoming",
          },
          {
            "id": "9",
            "title": "الكيمياء",
            "description": "Organic chemistry basics",
            "startTime": DateTime(date.year, date.month, date.day, 13, 30).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 15, 0).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Chemistry",
            "teacherId": "teacher7",
            "location": "Lab 3",
            "type": "classType",
            "status": "upcoming",
          },
        ];
        break;
        
      case DateTime.thursday:
        mockJsonList = [
          {
            "id": "10",
            "title": "الأحياء",
            "description": "Cell biology and genetics",
            "startTime": DateTime(date.year, date.month, date.day, 9, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 10, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Biology",
            "teacherId": "teacher8",
            "location": "Lab 4",
            "type": "classType",
            "status": "upcoming",
          },
          {
            "id": "11",
            "title": "الأدب",
            "description": "Arabic literature and poetry",
            "startTime": DateTime(date.year, date.month, date.day, 11, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 12, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Arabic",
            "teacherId": "teacher9",
            "location": "Room 204",
            "type": "classType",
            "status": "upcoming",
          },
          {
            "id": "12",
            "title": "الحاسوب",
            "description": "Programming and algorithms",
            "startTime": DateTime(date.year, date.month, date.day, 14, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 15, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Computer",
            "teacherId": "teacher10",
            "location": "Computer Lab",
            "type": "classType",
            "status": "completed",
          },
        ];
        break;
        
      case DateTime.sunday:
        mockJsonList = [
          {
            "id": "13",
            "title": "التربية الإسلامية",
            "description": "Islamic studies and ethics",
            "startTime": DateTime(date.year, date.month, date.day, 8, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 9, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Religion",
            "teacherId": "teacher11",
            "location": "Room 301",
            "type": "classType",
            "status": "completed",
          },
          {
            "id": "14",
            "title": "التربية البدنية",
            "description": "Sports and physical fitness",
            "startTime": DateTime(date.year, date.month, date.day, 10, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 11, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Sports",
            "teacherId": "teacher12",
            "location": "Gymnasium",
            "type": "classType",
            "status": "upcoming",
          },
          {
            "id": "15",
            "title": "الموسيقى",
            "description": "Music theory and practice",
            "startTime": DateTime(date.year, date.month, date.day, 13, 0).toIso8601String(),
            "endTime": DateTime(date.year, date.month, date.day, 14, 30).toIso8601String(),
            "className": "Grade 10A",
            "subject": "Music",
            "teacherId": "teacher13",
            "location": "Music Room",
            "type": "classType",
            "status": "upcoming",
          },
        ];
        break;
        
      default:
        mockJsonList = [];
    }

    final result = mockJsonList
        .map<ScheduleModel>((json) => ScheduleModel.fromJson(json))
        .toList();
    
    print('🔍 ScheduleRemoteDataSource: Returning ${result.length} schedules for ${date.weekday}');
    print('🔍 ScheduleRemoteDataSource: Schedules: ${result.map((s) => s.title).toList()}');
    
    return result;
  }

  // Test method to verify data is working
  Future<void> testData() async {
    print('🔍 ScheduleRemoteDataSource: Testing data...');
    final testDate = DateTime.now();
    final result = await getScheduleForDate(testDate);
    print('🔍 ScheduleRemoteDataSource: Test result: ${result.length} schedules');
  }
} 