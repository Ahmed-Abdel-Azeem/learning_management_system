import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/constants/globals.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_analytic_cubit.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_data_cubit.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_lessons_cubit.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/analytic.dart';
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
  bool _isEnrolled = false;

  Future<void> getEnrolled() async {
    try {
      final isEnrolled = await HomeCoursesService(ApiService())
          .chkenrollToCourse(productId: widget.courseId);

      if (mounted) {
        setState(() {
          _isEnrolled = isEnrolled;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isEnrolled = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<CourseDataCubit>().loadingCourse(widget.courseId);
    getEnrolled();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseDataCubit, CourseDataState>(
      builder: (context, state) {

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Suez Canal Authority LMS'),
              elevation: 0,
            ),
            bottomNavigationBar: !_isEnrolled
            ? Material(
                color: AppColors.primary,
                child: InkWell(
                  onTap: () async {
                    try {
                      await HomeCoursesService(ApiService())
                          .enrollToCourse(productId: widget.courseId);

                      if (mounted) {
                        setState(() {
                          _isEnrolled = true;
                        });

                        // Show success dialog and wait for it to close
                        if (mounted) {
                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (dialogContext) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              title: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                    size: 42,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Enrollment Successful',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'You have been enrolled to the course successfully.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(dialogContext); // Close dialog
                                  },
                                  child: const Text('OK',
                                      style:
                                          TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );

                          // After dialog closes, navigate back to home with success indicator
                          if (mounted) {
                            Navigator.pop(context, true);
                          }
                        }
                      }
                    } catch (error) {
                      if (mounted) {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            title: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.redAccent,
                                  size: 42,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Enrollment Failed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            content: Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.pop(dialogContext),
                                child: const Text('OK',
                                    style:
                                        TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  splashColor: Colors.white.withOpacity(0.2),
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
              )
            : null,
        body: state is CourseDataLoading
            ? const Center(child: CircularProgressIndicator())
            : state is CourseDataError
                ? Center(child: Text('Error: ${state.message}'))
                : state is CourseDataLoaded
                    ? ListView(
                children: [
                  state.course.courseImage != null &&
                          state.course.courseImage!.isNotEmpty
                      ? Image.network(
                          state.course.courseImage!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
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
                        BlocProvider(
                          create: (context) => CourseAnalyticCubit(
                              HomeCoursesService(ApiService()))
                            ..loadAnalytic(widget.courseId),
                          child: Analytic(
                            author: state.course.author,
                            label: (state.course.label ??
                                (state.course.author?.name ?? 'Unknown')),
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
                                desc: state.course.description ??
                                    'No description available',
                                categories: state.course.categories,
                              ),
                              BlocProvider(
                                create: (context) => _isEnrolled
                                    ? (CourseLessonsCubit(
                                        HomeCoursesService(ApiService()))
                                      ..loadContent(
                                          loginEmailController.text,
                                          state.course.id))
                                    : CourseLessonsCubit(
                                        HomeCoursesService(ApiService())),
                                child: Contents(
                                  courseId: state.course.id,
                                  isEnrolled: _isEnrolled,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Center(child: Text('No data')),
          ),
        );
      },
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

enum AppDialogType { success, error, warning }
