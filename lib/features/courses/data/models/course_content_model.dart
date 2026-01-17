class CourseContentModel {
  final String id;
  final String title;
  final List<SectionModel> sections;

  CourseContentModel({
    required this.id,
    required this.title,
    required this.sections,
  });

  factory CourseContentModel.fromJson(Map<String, dynamic> json) {
    return CourseContentModel(
      id: json['id'],
      title: json['title'],
      sections: (json['sections'] as List)
          .map((section) => SectionModel.fromJson(section))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }
}

// Example data - remove this after creating the section model

class SectionModel {
  final String id;
  final String title;
  final String description;
  final String access;
  final dynamic drip;
  final List<LearningUnitModel> learningUnits;

  SectionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.access,
    required this.drip,
    required this.learningUnits,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      access: json['access'],
      drip: json['drip'],
      learningUnits: (json['learningUnits'] as List)
          .map((unit) => LearningUnitModel.fromJson(unit))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'access': access,
      'drip': drip,
      'learningUnits': learningUnits.map((unit) => unit.toJson()).toList(),
    };
  }
}

class LearningUnitModel {
  final String id;
  final String type;
  final String icon;
  final String title;
  final String subtitle;

  LearningUnitModel({
    required this.id,
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  factory LearningUnitModel.fromJson(Map<String, dynamic> json) {
    return LearningUnitModel(
      id: json['id'],
      type: json['type'],
      icon: json['icon'],
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'icon': icon,
      'title': title,
      'subtitle': subtitle,
    };
  }
}
