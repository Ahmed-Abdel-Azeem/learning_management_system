import 'package:dio/dio.dart';
import 'package:learning_management_system/core/service/api.dart';

class HomeCoursesService {
  final ApiService _apiService;

  HomeCoursesService(this._apiService);

  Future<Response> getAllCourses() {
    return _apiService.dio.get('/courses');
  }

  Future<Response> enrollToCourse(String courseId) {
    return _apiService.dio.get('/users/$courseId/courses');
  }
}
