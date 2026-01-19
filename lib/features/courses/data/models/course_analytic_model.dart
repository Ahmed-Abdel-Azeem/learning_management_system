class CourseAnalyticModel {
  final int students;
  final int videos;
  final int learningUnits;
  final int videoTime;
  final num avgScoreRate;
  final num successRate;
  final int totalStudyTime;
  final int avgTimeToFinish;
  final int socialInteractions;
  final int certificatesIssued;
  final int videoViewingTime;
  CourseAnalyticModel({
    required this.students,
    required this.videos,
    required this.learningUnits,
    required this.videoTime,
    required this.videoViewingTime,
    required this.avgScoreRate,
    required this.successRate,
    required this.totalStudyTime,
    required this.avgTimeToFinish,
    required this.socialInteractions,
    required this.certificatesIssued,
  });

  factory CourseAnalyticModel.fromJson(Map<String, dynamic> json) {
    return CourseAnalyticModel(
      students: json['students'],
      videos: json['videos'],
      learningUnits: json['learning_units'],
      videoTime: json['video_time'],
      videoViewingTime: json['video_viewing_time'],
      avgScoreRate: json['avg_score_rate'],
      successRate: json['success_rate'],
      totalStudyTime: json['total_study_time'],
      avgTimeToFinish: json['avg_time_to_finish'],
      socialInteractions: json['social_interactions'],
      certificatesIssued: json['certificates_issued'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'students': students,
      'videos': videos,
      'learning_units': learningUnits,
      'video_time': videoTime,
      'avg_score_rate': avgScoreRate,
      'success_rate': successRate,
      'total_study_time': totalStudyTime,
      'avg_time_to_finish': avgTimeToFinish,
      'social_interactions': socialInteractions,
      'certificates_issued': certificatesIssued,
      'video_viewing_time': videoViewingTime,
    };
  }
}



// {
//     "students": 15,
//     "videos": 1,
//     "learning_units": 7,
//     "video_time": 327,
//     "avg_score_rate": 68,
//     "success_rate": 6.666,
//     "total_study_time": 77699,
//     "avg_time_to_finish": 1,
//     "social_interactions": 0,
//     "certificates_issued": 0,
//     "video_viewing_time": 969
// }