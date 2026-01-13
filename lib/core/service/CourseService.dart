import 'package:dio/dio.dart';
import 'package:learning_management_system/core/service/api.dart';

class CourseService {
  final ApiService _apiService;

  CourseService(this._apiService);

  Future<Response> getCourses() {
    return _apiService.dio.get('/courses');
  }

  Future<Response> enrollToCourse(String courseId) {
    return _apiService.dio.get('/users/$courseId/courses');
  }
}
