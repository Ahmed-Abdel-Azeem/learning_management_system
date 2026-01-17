import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_state.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';

class SearchCubit extends Cubit<CourseState> {
  final List<Course> _allCourses = [];

  SearchCubit() : super(CourseLoaded([]));

  void initCourses(List<Course> courses) {
    _allCourses.clear();
    _allCourses.addAll(courses);
    emit(CourseLoaded(List.from(_allCourses)));
  }

  void searchCourses({String? query, String? category}) {
    List<Course> results = List.from(_allCourses);

    // Filter by query
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results.where((course) {
        final title = course.title.toLowerCase();
        final description = course.description?.toLowerCase() ?? '';
        return title.contains(q) || description.contains(q);
      }).toList();
    }

    // Filter by category
    if (category != null && category.isNotEmpty) {
      results = results.where((c) => c.categories.contains(category)).toList();
    }

    emit(CourseLoaded(results));
  }
}
