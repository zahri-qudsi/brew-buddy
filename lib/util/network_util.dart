import 'dart:async';
import 'dart:convert';
import 'package:brew_buddy/config.dart';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static final NetworkUtil _instance = NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = const JsonDecoder();

  Future<dynamic> get(url, {Map<String, String>? headers, body}) {
    return http
        .get(Uri.https(BASE_URL, API_URL + url, body), headers: headers)
        .then((http.Response response) {
      final String res = response.body;

      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception(response.reasonPhrase);
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(url, {Map<String, String>? headers, body, encoding}) {
    try {
      final authToken = http
          .post(Uri.https(BASE_URL, API_URL + url),
              body: body, headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;

        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == "") {
          final dynamic error = jsonDecode(res);

          throw Exception(error['message']);
        }

        return _decoder.convert(res);
      });

      return authToken;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
