part of 'course_content_cubit.dart';

@immutable
sealed class CourseContentState {}

final class CourseContentLoading extends CourseContentState {}

final class CourseContentLoaded extends CourseContentState {
  final CourseContentModel content;

  CourseContentLoaded(this.content);
}

final class CourseContentError extends CourseContentState {
  final String message;

  CourseContentError(this.message);
}
