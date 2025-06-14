import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApiService {
  static late Dio _dio;
  static const String baseUrl = 'http://192.168.43.169'; // server url
  static late Uri baseUri;
  static String? token;
  static String prefix = '/api/';

  static init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    baseUri = Uri.parse(baseUrl);
    print('host ${baseUri.host}');
    print('scheme ${baseUri.scheme}');
    BaseOptions options = BaseOptions(
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.acceptHeader: 'application/json',
      },
      
      contentType: 'application/json',
      responseType: ResponseType.json,
      baseUrl: baseUrl,
    );
    _dio = Dio(options);
  }

  // /stories/public/api/v1/stories/users_stories ToDo end point to test
  //end point means the suffix string after the server url

  static Future<Response> postMethod(
      {required String endPoint,
      Map<String, dynamic>? queryParameters,
      FormData? formData,
      }) async {
    Uri uri = Uri(
      host: baseUri.host,
      port: 8000,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
      queryParameters: queryParameters,
    );
    return _dio.postUri(uri, data: formData);
  }

  static Future<Response> putMethod(
      {required String endPoint,
      Map<String, dynamic>? queryParameters,
        FormData? formData,}) async {
    Uri uri = Uri(
      host: baseUri.host,
      port: 8000,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
      queryParameters: queryParameters,
    );
    return _dio.putUri(uri, data: formData);
  }

  static Future<Response> getMethod(
      {required String endPoint, Map<String, dynamic>? queryParameters, Map<String, dynamic>? body}) async {
    Uri uri = Uri(
      host: baseUri.host,
      port: 8000,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
      queryParameters: queryParameters,
    );
    return _dio.getUri(uri,data:body ); // get request does not contain a body
  }

  static Future<Response> deleteMethod(
      {required String endPoint, Map<String, dynamic>? queryParameters}) async {
    Uri uri = Uri(
      host: baseUri.host,
      port: 8000,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
      queryParameters: queryParameters,
    );
    return _dio.deleteUri(uri); // delete request does not contain a body
  }

  static Future<Response> patchMethod(
      {required String endPoint, Map<String, dynamic>? body}) async {
    Uri uri = Uri(
      host: baseUri.host,
      port: 8000,
      scheme: baseUri.scheme,
      path: prefix + endPoint,
    );
    return _dio.patchUri(uri,
        data: body); // get request does not contain a body
  }
}
