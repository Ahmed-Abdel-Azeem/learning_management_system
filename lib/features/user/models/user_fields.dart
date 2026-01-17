class UserFields {
  final String? bio;
  final String? location;
  final String? url;
  final String? fb;
  final String? twitter;
  final String? instagram;
  final String? linkedin;
  final String? skype;
  final String? behance;
  final String? dribbble;
  final String? github;
  final String? phone;
  final String? address;
  final String? country;
  final String? birthday;
  final String? company;
  final String? companySize;
  final String? university;
  final String? graduationYear;
  final String? cfSkill;
  final String? cfStudentLicence;

  UserFields({
    this.bio,
    this.location,
    this.url,
    this.fb,
    this.twitter,
    this.instagram,
    this.linkedin,
    this.skype,
    this.behance,
    this.dribbble,
    this.github,
    this.phone,
    this.address,
    this.country,
    this.birthday,
    this.company,
    this.companySize,
    this.university,
    this.graduationYear,
    this.cfSkill,
    this.cfStudentLicence,
  });

  factory UserFields.fromJson(Map<String, dynamic> json) {
    return UserFields(
      bio: json['bio'],
      location: json['location'],
      url: json['url'],
      fb: json['fb'],
      twitter: json['twitter'],
      instagram: json['instagram'],
      linkedin: json['linkedin'],
      skype: json['skype'],
      behance: json['behance'],
      dribbble: json['dribbble'],
      github: json['github'],
      phone: json['phone'],
      address: json['address'],
      country: json['country'],
      birthday: json['birthday'],
      company: json['company'],
      companySize: json['company_size'],
      university: json['university'],
      graduationYear: json['graduation_year'],
      cfSkill: json['cf_skill'],
      cfStudentLicence: json['cf_studentlicence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'location': location,
      'url': url,
      'fb': fb,
      'twitter': twitter,
      'instagram': instagram,
      'linkedin': linkedin,
      'skype': skype,
      'behance': behance,
      'dribbble': dribbble,
      'github': github,
      'phone': phone,
      'address': address,
      'country': country,
      'birthday': birthday,
      'company': company,
      'company_size': companySize,
      'university': university,
      'graduation_year': graduationYear,
      'cf_skill': cfSkill,
      'cf_studentlicence': cfStudentLicence,
    };
  }
}
