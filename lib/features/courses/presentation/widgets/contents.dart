import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/providers/user_provider.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_lessons_cubit.dart';
import 'package:learning_management_system/features/courses/data/models/course_lessons_model.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/LessonWebViewPage.dart';
import 'package:learning_management_system/theme/app_theme.dart';

class Contents extends StatelessWidget {
  final String courseId;
  final bool isEnrolled;
  const Contents({super.key, required this.courseId, required this.isEnrolled});
  @override
  Widget build(BuildContext context) {
    // If not enrolled, show enrollment message instead of trying to load lessons
    if (!isEnrolled) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Enroll in this course',
              style: AppTextStyles.headline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Please enroll in this course to access the lessons and content',
              style: AppTextStyles.body.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return BlocBuilder<CourseLessonsCubit, CourseLessonsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: switch (state) {
            CourseLessonsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            CourseLessonsLoaded() => _buildContentList(
              state.content,
              context,
              courseId,
              isEnrolled,
              context.read<UserProvider>().user?.email ?? '',
            ),
            CourseLessonsError() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    isEnrolled ? 'No lessons available' : 'Enroll in this course to view lessons',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: AppTextStyles.small.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          },
        );
      },
    );
  }
}

Widget _buildContentList(
  CourseLessonsModel content,
  BuildContext context,
  String courseId,
  bool isEnrolled,
  String userEmail,
) {
  // Check if course has no content
  if (content.progressPerSectionUnit.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'No Content Available',
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'This course doesn\'t have any lessons yet',
            style: AppTextStyles.body.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  return ListView(
    children: [
      Text('Course Contents', style: AppTextStyles.headline),
      const SizedBox(height: 12),
      ...content.progressPerSectionUnit.map(
        (unit) => ExpansionTile(
          title: Text(
            unit.units[0].unitSectionName,
            style: AppTextStyles.title,
          ),
          children: unit.units.map((lesson) {
            return ListTile(
              title: InkWell(
                onTap: () {
                  if (isEnrolled) {
                    openLesson(context, courseId, lesson, userEmail);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You are not enrolled in this course'),
                      ),
                    );
                  }
                },
                child: Text(
                  lesson.unitName,
                  style: AppTextStyles.body.copyWith(
                    color: lesson.unitProgressRate == 100
                        ? Colors.black54
                        : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              subtitle:
                  (lesson.unitDuration != null && lesson.unitDuration! > 0)
                  ? Text(
                      _formatDuration(lesson.unitDuration!),
                      style: AppTextStyles.small.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    )
                  : null,
              trailing: Icon(
                lesson.unitStatus == 'completed' ||
                        lesson.unitProgressRate == 100
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                weight: 700,
                size: 32,
                color: lesson.unitProgressRate == 100
                    ? Colors.green
                    : Colors.grey,
              ),
              leading: Icon(
                _lessonIcon(lesson.unitType),
                color: lesson.unitProgressRate == 100
                    ? Colors.green
                    : AppColors.primary,
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}

String _formatDuration(int seconds) {
  final minutes = seconds ~/ 60;
  return '$minutes min';
}

IconData _lessonIcon(String type) {
  switch (type.toLowerCase()) {
    case 'video':
    case 'ivideo':
      return Icons.play_circle_outline;
    case 'url':
      return Icons.link;
    case 'ppt':
    case 'pptx':
    case 'slideshow':
      return Icons.slideshow;
    case 'pdf':
      return Icons.picture_as_pdf;

    case 'pbebook':
      return Icons.book;

    case 'article':
      return Icons.article;

    case 'scorm':
      return Icons.extension;

    case 'quiz':
      return Icons.quiz;
    case 'assignment':
    case 'assessmentV2':
      return Icons.assignment_outlined;
    default:
      return Icons.menu_book; //pbEbook,pdf,//pbEbook,pdf, scorm, quiz, article
  }
}

void openLesson(
  BuildContext context,
  String courseId,
  Unit lesson,
  String userEmail,
) async {
  late final String url;
  url =
      'https://suezcanal.learnworlds.com/path-player?courseid=$courseId&unit=${lesson.unitId}';

  // Open the lesson and wait for user to return
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => LessonWebViewPage(url: url)),
  );

  // After returning from lesson, mark it as complete and refresh progress
  if (context.mounted) {
    try {
      await context.read<CourseLessonsCubit>().markLessonComplete(
        userId: userEmail,
        courseId: courseId,
        lessonId: lesson.unitId,
      );
      
      debugPrint('✅ Lesson marked complete and content refreshed');
    } catch (e) {
      debugPrint('⚠️ Failed to mark lesson complete: $e');
    }
  }
}



//   Widget _buildContentList(CourseContentModel content) {
//     return ListView(
//       children: [
//         Text('Course Contents', style: AppTextStyles.headline),
//         const SizedBox(height: 12),
//         ...content.sections.map(
//           (section) => ExpansionTile(
//             title: Text(section.title, style: AppTextStyles.title),
//             children: section.learningUnits
//                 .map(
//                   (lesson) => ListTile(
//                     title: InkWell(
//                       onTap: () {
//                         Navigator.push(
                          
//                           MaterialPageRoute(
//                             builder: (_) => LessonVideoPage(
//                               lessonUrl:
//                                   'https://suezcanal.learnworlds.com/path-player?courseid=digital-transformation-from-analysis-to-strategy&unit=691ac0da6fb600aa060c3877Unit',
//                               //'https://suezcanal.learnworlds.com/video/VIDEO_ID',

//                               // أو
//                               // 'https://suezcanal.learnworlds.com/course/course-slug/lesson/LESSON_ID'
//                             ),
//                           ),
//                         );

//                         // HomeCoursesService(
//                         //   ApiService(),
//                         // ).getLessonContent(content.id, lesson.id);
//                         // Handle lesson tap
//                         // context.read<CourseContentCubit>().loadLessonContent(section.id, lesson.id);
//                       },
//                       child: Text(lesson.title, style: AppTextStyles.body),
//                     ),
//                     trailing: Text(
//                       section.access == 'free' ? 'Free' : 'Paid',
//                       style: AppTextStyles.body.copyWith(
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }
