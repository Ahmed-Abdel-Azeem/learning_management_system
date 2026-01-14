import 'package:bloc/bloc.dart';
import 'package:learning_management_system/features/search/data/repository/CoursesRepository.dart';
import 'package:learning_management_system/features/shared/Models/Course.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

//get data from Repository as couses model
//handel data in ui
// handel errors

class HomeCubit extends Cubit<HomeState> {
  final CoursesRepository repository;

  HomeCubit(this.repository) : super(HomeInitial());

  Future<void> getAllCourses() async {
    emit(HomeLoading());

    try {
      final courses = await repository.getAllCourses();

      final categories = courses
          .expand((course) => course.categories)
          .toSet()
          .toList();

      emit(HomeLoaded(courses, categories));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
