import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_analytic_cubit.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_content_cubit.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_data_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/analytic.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/authorInfo.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/contents.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/overView.dart';
import 'package:learning_management_system/features/shared/Models/auther_model.dart';
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
            onTap: () async {
              //  print(widget.courseId);
              //context.read<CourseDataCubit>().enrollToCourse(widget.courseId);
              await HomeCoursesService(ApiService())
                  .enrollToCourse(productId: widget.courseId)
                  .then((value) {
                    showAppDialog(
                      context: context,
                      title: 'Enrollment Successful',
                      message:
                          'You have been enrolled to the course successfully.',
                      type: AppDialogType.success,
                    );
                  })
                  .catchError((error) {
                    showAppDialog(
                      context: context,
                      title: 'Enrollment Failed',
                      message: error.toString(),
                      type: AppDialogType.error,
                    );
                  });
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
                  // Image.network(
                  //   state.course.courseImage!,//to be moidified if no image
                  //   fit: BoxFit.cover,
                  //   height: 250,
                  //   width: double.infinity,
                  // ),
                  state.course.courseImage != null &&
                          state.course.courseImage!.isNotEmpty
                      ? Image.network(
                          state.course.courseImage!,
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
                          create: (context) => CourseAnalyticCubit(
                            HomeCoursesService(ApiService()),
                          )..loadAnalytic(widget.courseId),
                          child: Analytic(
                            author: //state.course.author!
                                state.course.author ?? Author(name: 'Unknown'),
                            label:
                                (state.course.label ??
                                (state.course.author?.name ?? '')),
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
                                desc:
                                    state.course.description ??
                                    'No description available',
                                categories: state.course.categories,
                              ),

                              BlocProvider(
                                create: (context) => CourseContentCubit(
                                  HomeCoursesService(ApiService()),
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

void showAppDialog({
  required BuildContext context,
  required String title,
  required String message,
  required AppDialogType type,
}) {
  IconData icon;
  Color color;

  switch (type) {
    case AppDialogType.success:
      icon = Icons.check_circle_outline;
      color = Colors.green;
      break;
    case AppDialogType.error:
      icon = Icons.error_outline;
      color = Colors.redAccent;
      break;
    case AppDialogType.warning:
      icon = Icons.warning_amber_rounded;
      color = Colors.orange;
      break;
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 42),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

enum AppDialogType { success, error, warning }
