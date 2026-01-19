part of 'course_data_cubit.dart';

sealed class CourseDataState {}

final class CourseDataLoading extends CourseDataState {}

final class CourseDataLoaded extends CourseDataState {
  final Course course;

  CourseDataLoaded(this.course);
}

final class CourseDataError extends CourseDataState {
  final String message;

  CourseDataError(this.message);
}
