class CourseLessonsModel {
  final String status;
  final int progressRate;
  final int averageScoreRate;
  final int timeOnCourse;
  final int totalUnits;
  final int completedUnits;
  final List<ProgressPerSectionUnit> progressPerSectionUnit;
  final DateTime? completedAt;

  CourseLessonsModel({
    required this.status,
    required this.progressRate,
    required this.averageScoreRate,
    required this.timeOnCourse,
    required this.totalUnits,
    required this.completedUnits,
    required this.progressPerSectionUnit,
    required this.completedAt,
  });

  factory CourseLessonsModel.fromJson(Map<String, dynamic> json) {
    return CourseLessonsModel(
      status: json['status'],
      progressRate: json['progress_rate'],
      averageScoreRate: json['average_score_rate'],
      timeOnCourse: json['time_on_course'],
      totalUnits: json['total_units'],
      completedUnits: json['completed_units'],
      progressPerSectionUnit: (json['progress_per_section_unit'] as List)
          .map((e) => ProgressPerSectionUnit.fromJson(e))
          .toList(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }
}

class ProgressPerSectionUnit {
  final String sectionId;
  final List<Unit> units;

  ProgressPerSectionUnit({required this.sectionId, required this.units});

  factory ProgressPerSectionUnit.fromJson(Map<String, dynamic> json) {
    return ProgressPerSectionUnit(
      sectionId: json['section_id'],
      units: (json['units'] as List).map((e) => Unit.fromJson(e)).toList(),
    );
  }
}

class Unit {
  final String unitSectionName;
  final String unitId;
  final String unitName;
  final String unitType;
  final String unitStatus;
  final int? unitDuration;
  final int timeOnUnit;
  final int? scoreOnUnit;
  final int unitProgressRate;

  Unit({
    required this.unitSectionName,
    required this.unitId,
    required this.unitName,
    required this.unitType,
    required this.unitStatus,
    required this.unitDuration,
    required this.timeOnUnit,
    required this.scoreOnUnit,
    required this.unitProgressRate,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      unitSectionName: json['unit_section_name'],
      unitId: json['unit_id'],
      unitName: json['unit_name'],
      unitType: json['unit_type'],
      unitStatus: json['unit_status'],
      unitDuration: json['unit_duration'],
      timeOnUnit: json['time_on_unit'],
      scoreOnUnit: json['score_on_unit'],
      unitProgressRate: json['unit_progress_rate'],
    );
  }
}
