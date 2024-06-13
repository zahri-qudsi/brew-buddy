class TokenModel {
  late String token;

  TokenModel({
    required this.token,
  });

  TokenModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;

    return data;
  }
}
