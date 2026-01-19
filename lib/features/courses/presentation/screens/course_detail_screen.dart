import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/service/CourseService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_analytic_cubit.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_content_cubit.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_data_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/analytic.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/contents.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/overView.dart';
import 'package:learning_management_system/theme/app_theme.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key, required this.courseId});
  final String courseId;
  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CourseDataCubit>().loadingCourse(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: Material(
          color: AppColors.primary,
          child: InkWell(
            onTap: () {
              print(widget.courseId);
              // context.read<CourseDataCubit>().enrollToCourse(widget.courseId);
            },
            splashColor: Colors.white.withValues(alpha: 0.2),
            highlightColor: Colors.transparent,
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: const Text(
                'Enroll Course',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<CourseDataCubit, CourseDataState>(
          builder: (context, state) {
            if (state is CourseDataLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CourseDataError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is CourseDataLoaded) {
              // Here you can access the course data using state.course
              return ListView(
                children: [
                  Image.network(
                    state.course.courseImage!,
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                state.course.title,
                                style: AppTextStyles.headline,
                              ),
                            ),
                            Icon(
                              Icons.bookmark_border,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // 4. Author Info
                        BlocProvider(
                          create: (context) =>
                              CourseAnalyticCubit(CourseService(ApiService()))
                                ..loadAnalytic(widget.courseId),
                          child: Analytic(
                            author: state.course.author!,
                            label: state.course.label!,
                          ),
                        ),
                        const SizedBox(height: 15),

                        const TabBar(
                          indicatorColor: AppColors.primary,
                          tabs: [
                            Tab(text: 'overview'),
                            Tab(text: 'lessons'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 600,

                          child: TabBarView(
                            children: [
                              Overview(
                                desc: state.course.description!,
                                categories: state.course.categories,
                              ),

                              BlocProvider(
                                create: (context) => CourseContentCubit(
                                  CourseService(ApiService()),
                                )..loadContent(state.course.id),
                                child: Contents(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('No data'));
          },
        ),
      ),
    );
  }
}
