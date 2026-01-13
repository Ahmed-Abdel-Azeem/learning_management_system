class AfterPurchaseSettings {
  final String? url;
  final String? page;

  AfterPurchaseSettings({this.url, this.page});

  factory AfterPurchaseSettings.fromJson(Map<String, dynamic> json) {
    return AfterPurchaseSettings(url: json['url'], page: json['page']);
  }
}
