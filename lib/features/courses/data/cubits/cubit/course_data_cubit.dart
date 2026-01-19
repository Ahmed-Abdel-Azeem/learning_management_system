import 'package:bloc/bloc.dart';
import 'package:learning_management_system/core/service/CourseService.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';

part 'course_data_state.dart';

class CourseDataCubit extends Cubit<CourseDataState> {
  final CourseService service;
  CourseDataCubit(this.service) : super(CourseDataLoading());

  Future<void> loadingCourse(String courseId) async {
    emit(CourseDataLoading());
    try {
      final course = await service.getAcourse(courseId);
      emit(CourseDataLoaded(course));
    } catch (e) {
      emit(CourseDataError(e.toString()));
    }
  }
}
