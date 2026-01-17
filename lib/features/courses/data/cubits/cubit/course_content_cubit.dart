import 'package:bloc/bloc.dart';
import 'package:learning_management_system/core/service/CourseService.dart';
import 'package:learning_management_system/features/courses/data/models/course_content_model.dart';
import 'package:meta/meta.dart';

part 'course_content_state.dart';

class CourseContentCubit extends Cubit<CourseContentState> {
  final CourseService service;
  CourseContentCubit(this.service) : super(CourseContentLoading());

  Future<void> loadContent(String courseId) async {
    emit(CourseContentLoading());
    try {
      final content = await service.getCourseContent(courseId);
      emit(CourseContentLoaded(content));
    } catch (e) {
      emit(CourseContentError(e.toString()));
    }
  }
}
