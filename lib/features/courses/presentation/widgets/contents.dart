import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            ),
            CourseLessonsError() => Center(child: Text('No Data')),
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
) {
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
                    openLesson(context, courseId, lesson);
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
                //Text(lesson.unitName, style: AppTextStyles.body),
              ),
              subtitle:
                  (lesson.unitDuration != null && lesson.unitDuration! > 0)
                  ? Text(
                      _formatDuration(lesson.unitDuration!),
                      style: AppTextStyles.small.copyWith(
                        color: Colors.grey.shade600, // AppColors.textSecondary,
                      ),
                    )
                  : null,
              trailing: Icon(
                lesson.unitStatus == 'completed' ||
                        lesson.unitProgressRate == 100
                    ? Icons.check
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
              ), //Icon(_lessonIcon(lesson.unitType)),
              // leading: FaIcon(
              //   lesson.unitType == 'pdf'
              //       ? FontAwesomeIcons.filePdf
              //       : lesson.unitType == 'video' ||
              //             lesson.unitType == 'youtube' ||
              //             lesson.unitType == 'zoomMeeting'
              //       ? FontAwesomeIcons.circlePlay
              //       : lesson.unitType == 'slideshow' ||
              //             lesson.unitType == 'groupSession'
              //       ? FontAwesomeIcons.sliders
              //       : lesson.unitType == 'quiz' ||
              //             lesson.unitType == 'assessmentV2'
              //       ? FontAwesomeIcons.circleQuestion
              //       : lesson.unitType == 'url' || lesson.unitType == 'pbEbook'
              //       ? FontAwesomeIcons.link
              //       : lesson.unitType == 'certificate_v2'
              //       ? FontAwesomeIcons.circleQuestion
              //       : lesson.unitType == 'certificate'
              //       ? FontAwesomeIcons.certificate
              //       : null,
              //   color: AppColors.primary,
              //   size: 20,
              // ),
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

void openLesson(BuildContext context, String courseId, Unit lesson) {
  late final String url;
  url =
      'https://suezcanal.learnworlds.com/path-player?courseid=$courseId&unit=${lesson.unitId}';
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
