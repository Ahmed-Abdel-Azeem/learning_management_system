import 'package:equatable/equatable.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';

sealed class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

final class CourseInitial extends CourseState {
  const CourseInitial();
}

final class CourseLoading extends CourseState {
  const CourseLoading();
}

final class CourseLoaded extends CourseState {
  final List<Course> courses;
  const CourseLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

final class CourseFailure extends CourseState {
  final String errorMessage;
  const CourseFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
final class CourseEmpty extends CourseState {
  const CourseEmpty();
}