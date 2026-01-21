import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_management_system/features/home/presentation/Repository/UsersCourseRepository.dart';
import 'package:learning_management_system/features/home/presentation/viewModel/CourseUsersViewModel.dart';

part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesDataState> {
  final UsersCourseRepository repository;
  CoursesCubit(this.repository) : super(CoursesDataLoading());

  Future<void> loadCourses(String courseId) async {
    emit(CoursesDataLoading());
    try {
      final courses = await repository.getSuggestedCoursesWithUsersCount();
      emit(CoursesDataLoaded(courses));
    } catch (e) {
      emit(CoursesDataError(e.toString()));
    }
  }
Future<void> loadSuggestedCourses() async {
  emit(CoursesDataLoading());
  try {
    final courses = await repository.getSuggestedCoursesWithUsersCount(); 
   // final courseVMs = courses.map((c) => CourseUsersViewModel(course: c, usersCount: 0)).toList();
    emit(CoursesDataLoaded(courses));
  } catch (e) {
    emit(CoursesDataError(e.toString()));
  }
}

  
}
