import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/shared/Models/course_progress_response.dart';
import 'package:learning_management_system/features/user/models/user_model.dart';

class UserService {
  final ApiService _apiService;

  UserService(this._apiService);

  Future<UserModel> getUser(String email) async {
    try {
      final response = await _apiService.dio.get('/users/$email');

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception("User not found");
      } else if (e.response?.statusCode == 400) {
        throw Exception("Invalid email");
      } else {
        throw Exception("Connection error");
      }
    } catch (e) {
      throw Exception("Unexpected error");
    }
  }

  Future<UserModel> createUser({
    required String email,
    required String username,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/users',
        data: {"email": email, "username": username},
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception("Email already exists, try again");
      } else if (e.response?.statusCode == 400) {
        throw Exception("Invalid email");
      } else {
        throw Exception("Connection error");
      }
    } catch (e, st) {
      debugPrint('🔴 Unexpected: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  /// 🔹 Update username
  Future<UserModel> updateUsername(String email, String username) async {
    try {
      final response = await _apiService.dio.put(
        '/users/$email',
        data: {"email": email, "username": username},
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('🔴 DioException type: ${e.type}');
      debugPrint('🔴 status: ${e.response?.statusCode}');
      debugPrint('🔴 response: ${e.response?.data}');
      throw Exception("Failed to update username");
    } catch (e, st) {
      debugPrint('🔴 Unexpected: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  Future<CourseProgressResponse> getUserCourses(String email) async {
    try {
      final response = await _apiService.dio.get('/users/$email/progress');

      return CourseProgressResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('🔴 DioException type: ${e.type}');
      debugPrint('🔴 status: ${e.response?.statusCode}');
      debugPrint('🔴 response: ${e.response?.data}');
      debugPrint('🔴 message: ${e.message}');
      rethrow;
    } catch (e, st) {
      debugPrint('🔴 Unexpected: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  /// Get progress for a specific course
  /// Uses the API: /users/{id}/courses/{cid}/progress
  Future<Map<String, dynamic>> getCourseProgress(
    String userId,
    String courseId,
  ) async {
    try {
      final response = await _apiService.dio.get(
        '/users/$userId/courses/$courseId/progress',
      );
      return response.data;
    } on DioException catch (e) {
      debugPrint(
        '🔴 Failed to get progress for course $courseId: ${e.message}',
      );
      rethrow;
    } catch (e, st) {
      debugPrint('🔴 Unexpected error: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
