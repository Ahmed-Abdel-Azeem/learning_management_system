import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
}
