class AppConfig {

  bool showPrivateAd;

  AppConfig({
    this.showPrivateAd = false,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      showPrivateAd: json['show_private_ad'],
    );
  }
}