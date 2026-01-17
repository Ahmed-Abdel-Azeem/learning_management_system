import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_state.dart';
import 'package:learning_management_system/features/home/presentation/widgets/GridCourseCard.dart';
import 'course_card.dart';

class CourseGridView extends StatelessWidget {
  const CourseGridView({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(16),
            itemCount: state.courses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              return GridCourseCard(
                course  : state.courses[index]);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
