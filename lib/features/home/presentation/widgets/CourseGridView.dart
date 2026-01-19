import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_data_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_state.dart';
import 'package:learning_management_system/features/courses/presentation/screens/course_detail_screen.dart';
import 'package:learning_management_system/features/home/presentation/widgets/GridCourseCard.dart';

class CourseGridView extends StatelessWidget {
  const CourseGridView({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    int crossAxisCount = screenSize.width < 600 ? 1 : 2;
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CourseFailure) {
          return Center(child: Text(state.errorMessage));
        }

        if (state is CourseLoaded) {
          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: state.courses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: screenSize.width < 600 ? 1.1 : 0.9,
            ),
            itemBuilder: (context, index) {
              return GridCourseCard(
                course: state.courses[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          //CourseDetailsPage(course: state.courses[index]),
                          BlocProvider(
                            create: (context) => CourseDataCubit(
                              HomeCoursesService(ApiService()),
                            ),
                            child: CourseDetailScreen(
                              courseId: state.courses[index].id,
                            ),
                          ),
                    ),
                  );
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
