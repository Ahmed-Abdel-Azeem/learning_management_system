import 'package:bloc/bloc.dart';
import 'package:learning_management_system/core/service/CourseService.dart';
import 'package:learning_management_system/features/courses/data/models/course_analytic_model.dart';

part 'course_analytic_state.dart';

class CourseAnalyticCubit extends Cubit<CourseAnalyticState> {
  final CourseService service;
  CourseAnalyticCubit(this.service) : super(CourseAnalyticLoading());

  Future<void> loadAnalytic(String courseId) async {
    emit(CourseAnalyticLoading());
    try {
      final analytic = await service.getCourseAnalytic(courseId);
      emit(CourseAnalyticLoaded(analytic));
    } catch (e) {
      emit(CourseAnalyticError(e.toString()));
    }
  }
}
