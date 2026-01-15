class UnitProgress {
  final String? unitSectionName;
  final String? unitId;
  final String? unitName;
  final String? unitType;
  final String? unitStatus;
  final int? unitDuration;
  final int? timeOnUnit;
  final int? scoreOnUnit;
  final int? unitProgressRate;

  UnitProgress({
    required this.unitSectionName,
    required this.unitId,
    required this.unitName,
    required this.unitType,
    required this.unitStatus,
    required this.unitDuration,
    required this.timeOnUnit,
    this.scoreOnUnit,
    required this.unitProgressRate,
  });

  factory UnitProgress.fromJson(Map<String, dynamic> json) {
    return UnitProgress(
      unitSectionName: json['unit_section_name'] ?? '',
      unitId: json['unit_id'] ?? '',
      unitName: json['unit_name'] ?? '',
      unitType: json['unit_type'] ?? '',
      unitStatus: json['unit_status'] ?? '',
      unitDuration: json['unit_duration']?.toInt(),
      timeOnUnit: json['time_on_unit']?.toInt(),
      scoreOnUnit: json['score_on_unit']?.toInt(),
      unitProgressRate: json['unit_progress_rate']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'unit_section_name': unitSectionName,
    'unit_id': unitId,
    'unit_name': unitName,
    'unit_type': unitType,
    'unit_status': unitStatus,
    'unit_duration': unitDuration,
    'time_on_unit': timeOnUnit,
    'score_on_unit': scoreOnUnit,
    'unit_progress_rate': unitProgressRate,
  };
}
