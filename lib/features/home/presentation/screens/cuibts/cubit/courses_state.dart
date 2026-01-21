part of 'courses_cubit.dart';

abstract class CoursesDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class CoursesDataLoading extends CoursesDataState {}

final class CoursesDataLoaded extends CoursesDataState {
  final List<CourseUsersViewModel> courses;
  CoursesDataLoaded(this.courses);
  @override
  List<Object?> get props => [courses];
}

final class CoursesDataError extends CoursesDataState {
  final String errorMessage;

  CoursesDataError(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

class EnrollmentSuccess extends CoursesDataState {}
