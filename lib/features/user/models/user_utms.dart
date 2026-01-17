class UserUtms {
  final String? fcUtmSource;
  final String? fcUtmMedium;
  final String? fcUtmCampaign;
  final String? fcUtmTerm;
  final String? fcUtmContent;
  final String? fcLanding;
  final String? fcReferrer;
  final String? fcCountry;

  final String? lcUtmSource;
  final String? lcUtmMedium;
  final String? lcUtmCampaign;
  final String? lcUtmTerm;
  final String? lcUtmContent;
  final String? lcLanding;
  final String? lcReferrer;
  final String? lcCountry;

  UserUtms({
    this.fcUtmSource,
    this.fcUtmMedium,
    this.fcUtmCampaign,
    this.fcUtmTerm,
    this.fcUtmContent,
    this.fcLanding,
    this.fcReferrer,
    this.fcCountry,
    this.lcUtmSource,
    this.lcUtmMedium,
    this.lcUtmCampaign,
    this.lcUtmTerm,
    this.lcUtmContent,
    this.lcLanding,
    this.lcReferrer,
    this.lcCountry,
  });

  factory UserUtms.fromJson(Map<String, dynamic> json) {
    return UserUtms(
      fcUtmSource: json['fc_utm_source'],
      fcUtmMedium: json['fc_utm_medium'],
      fcUtmCampaign: json['fc_utm_campaign'],
      fcUtmTerm: json['fc_utm_term'],
      fcUtmContent: json['fc_utm_content'],
      fcLanding: json['fc_landing'],
      fcReferrer: json['fc_referrer'],
      fcCountry: json['fc_country'],
      lcUtmSource: json['lc_utm_source'],
      lcUtmMedium: json['lc_utm_medium'],
      lcUtmCampaign: json['lc_utm_campaign'],
      lcUtmTerm: json['lc_utm_term'],
      lcUtmContent: json['lc_utm_content'],
      lcLanding: json['lc_landing'],
      lcReferrer: json['lc_referrer'],
      lcCountry: json['lc_country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fc_utm_source': fcUtmSource,
      'fc_utm_medium': fcUtmMedium,
      'fc_utm_campaign': fcUtmCampaign,
      'fc_utm_term': fcUtmTerm,
      'fc_utm_content': fcUtmContent,
      'fc_landing': fcLanding,
      'fc_referrer': fcReferrer,
      'fc_country': fcCountry,
      'lc_utm_source': lcUtmSource,
      'lc_utm_medium': lcUtmMedium,
      'lc_utm_campaign': lcUtmCampaign,
      'lc_utm_term': lcUtmTerm,
      'lc_utm_content': lcUtmContent,
      'lc_landing': lcLanding,
      'lc_referrer': lcReferrer,
      'lc_country': lcCountry,
    };
  }
}
