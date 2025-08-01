import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class FetchingData {
  static const String baseUrl = "palm.moh-dhs.com";
  static Future<http.Response> postData(String provideUrl,
      Map<String, dynamic> param, Map<String, String> headers) async {
    var url = Uri.https(baseUrl.replaceAll('https://', ''), provideUrl);

    dynamic body;
    if (headers['Content-Type'] == 'application/x-www-form-urlencoded') {
      body = param;
    } else {
      body = json.encode(param);
    }
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future postHeaderFile(Map<String, String> header,
      Map<String, dynamic> parBody, File profileImg) async {
    var url = Uri.https(
        baseUrl.replaceAll('https://', ''), 'api/reading/buy-time-packages');
    var request = http.MultipartRequest('POST', url);
    var txnImage =
        await http.MultipartFile.fromPath('transaction_file', profileImg.path);
    request.files.add(txnImage);
    request.headers.addAll(header);
    parBody.forEach((key, value) {
      request.fields[key] = value;
    });
    var response = await request.send();
    var res = await http.Response.fromStream(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseDecode = json.decode(res.body);
      if (responseDecode['status'] == true) {
        return res.body;
      } else {
        return res.body;
      }
    }
  }

  static Future<http.Response> postHeader(String provideUrl,
      Map<String, String> param, Map<String, dynamic> parBody) async {
    var url = Uri.https(baseUrl.replaceAll('https://', ''), provideUrl);
    dynamic requestBody;
    if (param.containsKey('Content-Type') &&
        param['Content-Type'] == 'application/json') {
      requestBody = json.encode(parBody);
    } else {
      requestBody = parBody;
    }
    try {
      final response = await http
          .post(url, headers: param, body: requestBody)
          .timeout(const Duration(seconds: 30));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> getHeader(
      String provideUrl, Map<String, String> param) async {
    var url = Uri.https(baseUrl.replaceAll('https://', ''), provideUrl);
    try {
      final response = await http.get(url, headers: param);
      if (response.statusCode != 200) {}
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<http.Response> getData(
      String provideUrl, Map<String, String> param) async {
    var url = Uri.https(baseUrl.replaceAll('https://', ''), provideUrl);
    final response = await http.get(url, headers: param);
    if (response.statusCode != 200) {}
    return response;
  }

  static Future<http.Response> getDataPar(String provideUrl,
      Map<String, String> param, Map<String, String> header) async {
    var url = Uri.https(baseUrl.replaceAll('https://', ''), provideUrl, param);

    try {
      final response = await http
          .get(url, headers: header)
          .timeout(const Duration(seconds: 10));
      return response;
    } on SocketException {
      throw Exception('Network connection failed');
    } on TimeoutException {
      throw Exception('Request timed out');
    }
  }

  static Future<http.Response> postCart(
      String provideUrl,
      Map<String, dynamic> param,
      Map<String, String> header,
      Map<dynamic, dynamic> parBody) async {
    var url = Uri.https(baseUrl.replaceAll('https://', ''), provideUrl, param);
    final response = await http.post(url, headers: header, body: parBody);
    return response;
  }

  static Future<http.Response> deleteCart(String provideUrl,
      Map<String, dynamic> param, Map<String, String> header) async {
    var url = Uri.https(baseUrl.replaceAll('https://', ''), provideUrl, param);
    final response = await http.delete(url, headers: header);
    return response;
  }

  static Future<http.Response> updateCartQuantity(String provideUrl,
      Map<String, String> param, Map<String, dynamic> parBody) async {
    var url = Uri.https(baseUrl.replaceAll('https://', ''), provideUrl);
    dynamic requestBody = parBody;
    if (param.containsKey('Content-Type') &&
        param['Content-Type'] == 'application/json') {
      requestBody = json.encode(parBody);
    }
    final response = await http.post(url, headers: param, body: requestBody);
    return response;
  }

  static Future<http.Response> postHeaderMd5(
    String url,
    Map<String, String> headers,
    String md5,
  ) async {
    final body = jsonEncode({"md5": md5});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    return response;
  }
}
