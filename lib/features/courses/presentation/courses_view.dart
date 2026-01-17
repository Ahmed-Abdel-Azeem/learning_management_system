import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/api/course_api.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/course_state.dart';
import 'package:learning_management_system/features/courses/data/models/course_model.dart';

class CourseViewPage extends StatelessWidget {
  const CourseViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CourseCubit(CourseApi())..loadCourses(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Courses'),
        ),
        body: BlocBuilder<CourseCubit, CourseState>(
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
    return CourseCard(course: state.courses[index]);
  },
);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}


class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key,required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Column(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: course.courseImage != null &&
                      course.courseImage!.isNotEmpty
                  ? Image.network(
                      course.courseImage!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.white70,
                        ),
                      ),
                    ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Description
                  if (course.description != null &&
                      course.description!.isNotEmpty)
                    Text(
                      course.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),

                  const Spacer(),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A2E6D),
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                       Text(
                        course.access.toLowerCase() == 'free' 
                            ? 'Free'
                            : course.access,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


