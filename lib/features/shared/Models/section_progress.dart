import 'package:learning_management_system/features/shared/Models/unit_progress.dart';

class SectionProgress {
  final String sectionId;
  final List<UnitProgress> units;

  SectionProgress({required this.sectionId, required this.units});

  factory SectionProgress.fromJson(Map<String, dynamic> json) {
    return SectionProgress(
      sectionId: json['section_id'],
      units: (json['units'] as List<dynamic>)
          .map((e) => UnitProgress.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'section_id': sectionId,
    'units': units.map((e) => e.toJson()).toList(),
  };
}
