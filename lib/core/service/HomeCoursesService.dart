import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/core/constants/globals.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/models/course_analytic_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_content_model.dart';
import 'package:learning_management_system/features/courses/data/models/course_lessons_model.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';

class HomeCoursesService {
  final ApiService _apiService;

  HomeCoursesService(this._apiService);

  Future<Response> getAllCourses() {
    return _apiService.dio.get('/courses');
  }

  // Future<Response> enrollToCourse(String courseId) {
  //   return _apiService.dio.get('/users/$courseId/courses');
  // }

  Future<bool> enrollToCourse({required String productId}) async {
    try {
      final response = await _apiService.dio.post(
        '/users/${loginEmailController.text}/enrollment',
        data: {"productId": productId, "productType": "course", "price": 0},
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception("User already enrolled to this course");
      } else if (e.response?.statusCode == 401) {
        throw Exception("Unauthorized access");
      } else {
        throw Exception("Connection error");
      }
    } catch (e, st) {
      debugPrint('🔴 Unexpected: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  Future<bool> chkenrollToCourse({required String productId}) async {
    try {
      final response = await _apiService.dio.get(
        '/users/${loginEmailController.text}/courses',
      );

      if (response.data['data'] == null) {
        return false;
      }

      for (var element in response.data['data']) {
        final courseId = element['course']?['id']?.toString();

        if (courseId == productId) {
          return true;
        }
      }

      return false;
    } catch (e, st) {
      return false;
    }
  }

  // Future<bool> chkenrollToCourse({required String productId}) async {
  //   try {
  //     final response = await _apiService.dio.get(
  //       '/users/${loginEmailController.text}/courses',
  //     );

  //     response.data['data'].forEach((element) {
  //       if (element['course']['id'] == productId) {
  //         print(element['course']['id'] == productId);
  //         print(productId);
  //         return true;
  //       }
  //     });
  //   } catch (e) {
  //     throw Exception('Failed to load course: $e');
  //   }
  //   return false;
  // }

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
  // https://stoplight.io/mocks/learnworlds/api:main/2951998/v2/users/{id}/courses/{cid}/progress

  Future<CourseLessonsModel> getLessonProgress(
    String courseId,
    String userId,
  ) async {
    try {
      final response = await _apiService.dio.get(
        '/users/$userId/courses/$courseId/progress',
      );

      return CourseLessonsModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load lesson content: $e');
    }
  }

  //to be modified
  Future<CourseContentModel> getLessonContent(
    String courseId,
    String lessonId,
  ) async {
    try {
      final response = await _apiService.dio.get(
        '/courses/$courseId/contents/lessons/$lessonId',
      );
      return CourseContentModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load lesson content: $e');
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

  Future<int> getCourseUsersOnlyCount(String courseId) async {
    try {
      final response = await _apiService.dio.get('/courses/$courseId/users');

      final users = response.data['data'] as List;

      return users.where((u) {
        final role = u['role'];
        return role != null &&
            (role['level'] == 'user' || role['name'] == 'user');
      }).length;
    } catch (e) {
      debugPrint('users count failed for course $courseId');
      return 0;
    }
  }
}
