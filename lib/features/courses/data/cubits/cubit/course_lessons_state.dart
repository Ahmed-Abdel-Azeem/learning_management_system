part of 'course_lessons_cubit.dart';

sealed class CourseLessonsState extends Equatable {
  const CourseLessonsState();

  @override
  List<Object> get props => [];
}

final class CourseLessonsLoading extends CourseLessonsState {}

final class CourseLessonsLoaded extends CourseLessonsState {
  final CourseLessonsModel content;

  const CourseLessonsLoaded(this.content);
}

final class CourseLessonsError extends CourseLessonsState {
  final String message;

  const CourseLessonsError(this.message);
}
