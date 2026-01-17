import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/models/course_analytic_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_content_model.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';

class CourseService {
  final ApiService _apiService;

  CourseService(this._apiService);

  Future<Response> getCourses() {
    return _apiService.dio.get('/courses');
  }

  Future<Response> enrollToCourse(String courseId) {
    return _apiService.dio.get('/users/$courseId/courses');
  }

  Future<Course> getAcourse(String courseId) async {
    try {
      final response = await _apiService.dio.get('/courses/$courseId');
      return Course.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load course: $e');
    }
  }

  Future<CourseContentModel> getCourseContent(String courseId) async {
    try {
      final response = await _apiService.dio.get('/courses/$courseId/contents');
      return CourseContentModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load course content: $e');
    }
  }

  Future<CourseAnalyticModel> getCourseAnalytic(String courseId) async {
    try {
      final response = await _apiService.dio.get(
        '/courses/$courseId/analytics',
      );

      return CourseAnalyticModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load course analytic: $e');
    }
  }
}
