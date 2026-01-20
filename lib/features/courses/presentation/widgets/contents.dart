import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/core/service/HomeCoursesService.dart';
import 'package:learning_management_system/core/service/api.dart';
import 'package:learning_management_system/features/courses/data/cubits/cubit/course_content_cubit.dart';
import 'package:learning_management_system/features/courses/data/models/course_content_model.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/LessonWebViewPage.dart';
import 'package:learning_management_system/features/courses/presentation/widgets/lessonVideoPage.dart';
import 'package:learning_management_system/theme/app_theme.dart';

class Contents extends StatelessWidget {
  const Contents({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseContentCubit, CourseContentState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: switch (state) {
            CourseContentLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            CourseContentLoaded() => _buildContentList(state.content, context),
            CourseContentError() => Center(
              child: Text('Error: ${state.message}'),
            ),
          },
        );
      },
    );
  }
}

Widget _buildContentList(CourseContentModel content, BuildContext context) {
  return ListView(
    children: [
      Text('Course Contents', style: AppTextStyles.headline),
      const SizedBox(height: 12),
      ...content.sections.map(
        (section) => ExpansionTile(
          title: Text(section.title, style: AppTextStyles.title),
          children: section.learningUnits.map((lesson) {
            return ListTile(
              title: InkWell(
                onTap: () {
                  openLesson(context, content, lesson);
                },
                child: Text(lesson.title, style: AppTextStyles.body),
              ),
              trailing: Text(
                section.access == 'free' ? 'Free' : 'Paid',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}

void openLesson(
  BuildContext context,
  CourseContentModel content,
  LearningUnitModel lesson,
) {
  late final String url;
  url =
      'https://suezcanal.learnworlds.com/path-player?courseid=${content.id}&unit=${lesson.id}';
  // switch (lesson.type) {
  //   case 'video':
  //   case 'ivideo':
  //   case 'pdf':
  //   case 'ppt':
  //   case 'scorm':
  //   case 'quiz':
  //     url =
  //         'https://suezcanal.learnworlds.com/path-player?courseid=${content.id}&unit=${lesson.id}';

  //     //'https://suezcanal.learnworlds.com/course/$courseSlug/lesson/${lesson.slug}';
  //     break;

  //   default:
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Unsupported lesson type')));
  //     return;
  // }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => LessonWebViewPage(url: url)),
  );
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
