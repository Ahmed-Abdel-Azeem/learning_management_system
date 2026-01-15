import 'package:learning_management_system/features/user/models/user_fields.dart';
import 'package:learning_management_system/features/user/models/user_utms.dart';

class UserModel {
  final String id;
  final String email;
  final String? username;
  final bool? subscribedForMarketingEmails;
  final bool? euCustomer;
  final bool? isAdmin;
  final bool? isInstructor;
  final bool? isSuspended;
  final bool? isAffiliate;
  final String? referrerId;
  final double? created;
  final double? lastLogin;
  final String? signupApprovalStatus;
  final UserFields? fields;
  final List<String>? tags;
  final UserUtms? utms;
  final String? npsScore;
  final String? npsComment;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.subscribedForMarketingEmails,
    required this.euCustomer,
    required this.isAdmin,
    required this.isInstructor,
    required this.isSuspended,
    required this.isAffiliate,
    this.referrerId,
    required this.created,
    required this.lastLogin,
    required this.signupApprovalStatus,
    required this.fields,
    required this.tags,
    required this.utms,
    this.npsScore,
    this.npsComment,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      subscribedForMarketingEmails:
          json['subscribed_for_marketing_emails'] ?? false,
      euCustomer: json['eu_customer'] ?? false,
      isAdmin: json['is_admin'] ?? false,
      isInstructor: json['is_instructor'] ?? false,
      isSuspended: json['is_suspended'] ?? false,
      isAffiliate: json['is_affiliate'] ?? false,
      referrerId: json['referrer_id'] ?? '',
      created: json['created']?.toDouble(),
      lastLogin: json['last_login']?.toDouble(),
      signupApprovalStatus: json['signup_approval_status'] ?? '',
      fields: UserFields.fromJson(json['fields'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
      utms: UserUtms.fromJson(json['utms'] ?? {}),
      npsScore: json['nps_score'] ?? '',
      npsComment: json['nps_comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'subscribed_for_marketing_emails': subscribedForMarketingEmails,
      'eu_customer': euCustomer,
      'is_admin': isAdmin,
      'is_instructor': isInstructor,
      'is_suspended': isSuspended,
      'is_affiliate': isAffiliate,
      'referrer_id': referrerId,
      'created': created,
      'last_login': lastLogin,
      'signup_approval_status': signupApprovalStatus,
      'fields': fields?.toJson(),
      'tags': tags,
      'utms': utms?.toJson(),
      'nps_score': npsScore,
      'nps_comment': npsComment,
    };
  }
}
