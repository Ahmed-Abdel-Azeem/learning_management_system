part of 'course_analytic_cubit.dart';

sealed class CourseAnalyticState {}

final class CourseAnalyticLoading extends CourseAnalyticState {}

final class CourseAnalyticLoaded extends CourseAnalyticState {
  final CourseAnalyticModel analytic;
  CourseAnalyticLoaded(this.analytic);
}

final class CourseAnalyticError extends CourseAnalyticState {
  final String message;
  CourseAnalyticError(this.message);
}
