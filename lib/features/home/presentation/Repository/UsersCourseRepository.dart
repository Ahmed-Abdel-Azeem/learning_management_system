import 'package:learning_management_system/core/constants/globals.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/features/home/presentation/viewModel/CourseUsersViewModel.dart';
import 'package:learning_management_system/features/shared/Models/course.dart';

class UsersCourseRepository {
  final HomeCoursesService service;
  UsersCourseRepository(this.service);

  Future<CourseUsersViewModel> getCourseWithUsersCount(String courseId) async {
    final course = await service.getAcourse(courseId);
    final usersCount = await service.getCourseUsersOnlyCount(courseId);
    return CourseUsersViewModel(course: course, usersCount: usersCount);
  }

  Future<List<CourseUsersViewModel>> getSuggestedCoursesWithUsersCount() async {
    try {
      final allResponse = await service.getAllCourses();
      final allData = allResponse.data['data'] as List? ?? [];

      final enrolledCourses = await service.getUserCourses(loginEmailController.text);
      
      final enrolledSlugs = enrolledCourses
          .map((c) => c.identifiers.slug?.trim().toLowerCase())
          .toSet();

      final suggestedCourses = <CourseUsersViewModel>[];

      for (final courseJson in allData) {
        if (courseJson == null) continue;

        final course = Course.fromJson(courseJson);
        final slug = course.identifiers.slug?.trim().toLowerCase();

        if (!enrolledSlugs.contains(slug)) {
          final courseVM = await getCourseWithUsersCount(course.id);
          suggestedCourses.add(courseVM);
        }
      }

      return suggestedCourses;

    } catch (e) {
      print('Error loading suggested courses: $e');
      return [];
    }
  }
}
