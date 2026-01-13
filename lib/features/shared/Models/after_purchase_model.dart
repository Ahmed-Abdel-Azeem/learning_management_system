import 'after_purchase_settings_model.dart';

class AfterPurchase {
  final String type;
  final String? navigationType;
  final AfterPurchaseSettings settings;

  AfterPurchase({
    required this.type,
    this.navigationType,
    required this.settings,
  });

  factory AfterPurchase.fromJson(Map<String, dynamic> json) {
    return AfterPurchase(
      type: json['type'],
      navigationType: json['navigationType'],
      settings: AfterPurchaseSettings.fromJson(json['settings']),
    );
  }
}
