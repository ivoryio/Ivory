class OauthModel {
  late String tokenType;
  late int expiresIn;
  late String accessToken;

  OauthModel(
      {required this.tokenType,
      required this.expiresIn,
      required this.accessToken});

  OauthModel.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'] ?? '';
    expiresIn = json['expires_in'] ?? 0;
    accessToken = json['access_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['access_token'] = accessToken;
    return data;
  }
}
