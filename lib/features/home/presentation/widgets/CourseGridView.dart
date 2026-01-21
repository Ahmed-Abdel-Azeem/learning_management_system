import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_data_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/screens/course_detail_screen.dart';
import 'package:learning_management_system/features/home/presentation/screens/cuibts/cubit/courses_cubit.dart';
import 'package:learning_management_system/features/home/presentation/widgets/GridCourseCard.dart';

class CourseGridView extends StatefulWidget {
  final VoidCallback? onCourseEnrolled;
  
  const CourseGridView({super.key, this.onCourseEnrolled});

  @override
  State<CourseGridView> createState() => _CourseGridViewState();
}

class _CourseGridViewState extends State<CourseGridView> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    int crossAxisCount = screenSize.width < 600 ? 2 : 3;
    return BlocBuilder<CoursesCubit, CoursesDataState>(
      builder: (context, state) {
        if (state is CoursesDataLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CoursesDataError) {
          return Center(child: Text(state.errorMessage));
        }

        if (state is CoursesDataLoaded) {
          // Check if courses list is empty
          if (state.courses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 24),
                    const Text(
                      'No Courses Available Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Please wait for more courses to be added',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: state.courses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: screenSize.width < 600 ? 0.6 : 0.8,
            ),
            itemBuilder: (context, index) {
              return GridCourseCard(
                course: state.courses[index].course,
                participantsCount: state.courses[index].usersCount,
                onTap: () async {
                  // Navigate to CourseDetailScreen and wait for result
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => CourseDataCubit(
                          HomeCoursesService(ApiService()),
                        ),
                        child: CourseDetailScreen(
                          courseId: state.courses[index].course.id,
                        ),
                      ),
                    ),
                  );

                  // If enrollment was successful, refresh the courses and progress
                  if (result == true && mounted) {
                    context.read<CoursesCubit>().loadSuggestedCourses();
                    widget.onCourseEnrolled?.call();
                  }
                },
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
