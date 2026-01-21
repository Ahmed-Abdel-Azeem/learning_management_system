import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/providers/user_provider.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/presentation/screens/course_detail_screen.dart' show CourseDetailScreen;
import 'package:learning_management_system/features/home/presentation/Repository/UsersCourseRepository.dart';
import 'package:learning_management_system/features/home/presentation/screens/cuibts/cubit/courses_cubit.dart';
import 'package:provider/provider.dart';
import '../../../../theme/app_theme.dart';
import '../../../shared/Models/course.dart';
import '../../../courses/presentation/course_details_page.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key, required this.username});
  final String username;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late CoursesCubit _coursesCubit;

  @override
  void initState() {
    super.initState();

    // ✅ تأجيل الوصول للـ context بعد بناء الـ Widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<UserProvider>().user?.id ?? '';
      _coursesCubit = CoursesCubit(
        UsersCourseRepository(HomeCoursesService(ApiService())),
      );
      _coursesCubit.loadCourses(userId);
      setState(() {}); // إعادة بناء بعد إنشاء Cubit
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_coursesCubit == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocProvider<CoursesCubit>.value(
      value: _coursesCubit,
      child: BlocListener<CoursesCubit, CoursesDataState>(
        listener: (context, state) {
          if (state is EnrollmentSuccess) {
            final userId = context.read<UserProvider>().user?.id ?? '';
            _coursesCubit.loadSuggestedCourses();
          }
        },
        child: Column(
          children: [
            HeaderSection(username: widget.username),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<CoursesCubit, CoursesDataState>(
                builder: (context, state) {
                  if (state is CoursesDataLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CoursesDataLoaded) {
                    final courses = state.courses;
                    if (courses.isEmpty) {
                      return const Center(child: Text("No suggested courses."));
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index].course;
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: _coursesCubit,
                                child: CourseDetailScreen(courseId: course.id),
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blue[100],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: Image.network(
                                      course.courseImage ?? '',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    course.title,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is CoursesDataError) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= HEADER =================
class HeaderSection extends StatefulWidget {
  final String username;
  const HeaderSection({super.key, required this.username});

  @override
  State<HeaderSection> createState() => HeaderSectionState();
}

class HeaderSectionState extends State<HeaderSection> {
  @override
  Widget build(BuildContext context) {
    final scheme = AppColors.primarySwatch;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.shade500, scheme.shade700, scheme.shade900],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('lib/assets/images/logo1.png', height: 60, width: 90),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${widget.username}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Continue your learning journey',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}