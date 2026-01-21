import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/features/courses/data/models/course_lessons_model.dart';

part 'course_lessons_state.dart';

class CourseLessonsCubit extends Cubit<CourseLessonsState> {
  final HomeCoursesService service;
  CourseLessonsCubit(this.service) : super(CourseLessonsLoading());

  Future<void> loadContent(String userId, String courseId) async {
    emit(CourseLessonsLoading());
    try {
      final CourseLessonsModel content = await service.getLessonProgress(
        courseId,
        userId,
      );

      emit(CourseLessonsLoaded(content));
    } catch (e) {
      emit(CourseLessonsError(e.toString()));
    }
  }

  /// Mark a lesson as complete and reload content
  Future<void> markLessonComplete({
    required String userId,
    required String courseId,
    required String lessonId,
  }) async {
    try {
      await service.markLessonComplete(
        userId: userId,
        courseId: courseId,
        lessonId: lessonId,
      );
      
      // Reload content to update UI with completed lesson
      await loadContent(userId, courseId);
    } catch (e) {
      // Don't emit error state - just log the error and keep current lessons visible
      debugPrint('⚠️ Failed to mark lesson complete: $e');
      // State remains as CourseLessonsLoaded with current content
    }
  }

  /// Update time spent on course
  Future<void> updateTimeSpent({
    required String userId,
    required String courseId,
    required int minutesSpent,
  }) async {
    try {
      await service.updateTimeSpent(
        userId: userId,
        courseId: courseId,
        minutesSpent: minutesSpent,
      );
      
      // Reload content to update progress display
      await loadContent(userId, courseId);
    } catch (e) {
      emit(CourseLessonsError(e.toString()));
    }
  }
}
