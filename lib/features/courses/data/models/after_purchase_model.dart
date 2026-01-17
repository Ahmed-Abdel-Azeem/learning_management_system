import 'package:learning_management_system/features/shared/Models/after_purchase_settings_model.dart';

class AfterPurchase{
  final String type;
  final AfterPurchaseSettings settings;

  AfterPurchase({required this.type, required this.settings});

  factory AfterPurchase.fromJson(Map<String, dynamic> json){
    return AfterPurchase(
      type: json['type'],
      settings: AfterPurchaseSettings.fromJson( json['settings']));
  }
}