import 'package:learning_management_system/features/shared/Models/section_progress.dart';

class CourseProgress {
  final String courseId;
  final String status;
  final int progressRate;
  final int averageScoreRate;
  final int timeOnCourse;
  final int totalUnits;
  final int completedUnits;
  final int? completedAt;
  final List<SectionProgress> progressPerSectionUnit;

  CourseProgress({
    required this.courseId,
    required this.status,
    required this.progressRate,
    required this.averageScoreRate,
    required this.timeOnCourse,
    required this.totalUnits,
    required this.completedUnits,
    this.completedAt,
    required this.progressPerSectionUnit,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      courseId: json['course_id'],
      status: json['status'],
      progressRate: json['progress_rate'],
      averageScoreRate: json['average_score_rate'],
      timeOnCourse: json['time_on_course'],
      totalUnits: json['total_units'],
      completedUnits: json['completed_units'],
      completedAt: json['completed_at'],
      progressPerSectionUnit:
          (json['progress_per_section_unit'] as List<dynamic>)
              .map((e) => SectionProgress.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'course_id': courseId,
    'status': status,
    'progress_rate': progressRate,
    'average_score_rate': averageScoreRate,
    'time_on_course': timeOnCourse,
    'total_units': totalUnits,
    'completed_units': completedUnits,
    'completed_at': completedAt,
    'progress_per_section_unit': progressPerSectionUnit
        .map((e) => e.toJson())
        .toList(),
  };

  /// Create a copy with corrected progress for newly enrolled courses
  CourseProgress withCorrectedProgress() {
    // If course is not started OR is newly enrolled (0 progress, 0 time spent)
    if (status == 'not_started' || (progressRate == 0 && timeOnCourse == 0)) {
      return CourseProgress(
        courseId: courseId,
        status: status,
        progressRate: 0,
        averageScoreRate: 0,
        timeOnCourse: 0,
        totalUnits: 0, // Set to 0 to show 0% progress
        completedUnits: 0,
        completedAt: completedAt,
        progressPerSectionUnit: progressPerSectionUnit,
      );
    }
    // Return original if already started or completed
    return this;
  }
}
