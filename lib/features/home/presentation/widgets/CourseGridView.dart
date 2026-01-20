import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_data_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/screens/course_detail_screen.dart';
import 'package:learning_management_system/features/home/presentation/screens/cuibts/cubit/courses_cubit.dart';
import 'package:learning_management_system/features/home/presentation/widgets/GridCourseCard.dart';
import 'package:learning_management_system/features/shared/Models/Course.dart';

class CourseGridView extends StatelessWidget {
  const CourseGridView({super.key});

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
                              courseId: state.courses[index].course.id,
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
