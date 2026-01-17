class AfterPurchaseSettings {
  final String? page;
  final String? url;

  AfterPurchaseSettings({this.page, this.url});

  factory AfterPurchaseSettings.fromJson(Map<String, dynamic> json){
    return AfterPurchaseSettings(
      page: json['page'],
      url: json['url']
    );
  }
  }
