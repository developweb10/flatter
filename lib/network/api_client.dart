import 'package:http/http.dart' as http;
import 'package:krushapp/utils/app_exceptions.dart';
import 'dart:convert';

class ApiClient {
  final String baseUrl = 'https://krushin.site/api';
  http.Client httpClient = http.Client();

  Future<dynamic> getRequest({String urlSuffix, String authToken}) async {
    Map<String, String> headers;
    if (authToken != null) {
      headers = {
        "Content-type": "application/json",
        "Authorization": "bearer " + authToken
      };
    }

    try {
      final response =
          await httpClient.get("$baseUrl/$urlSuffix", headers: headers);
      return await _handleResponse(response);
    } catch (e) {
      print('error in get request $urlSuffix ${e.toString()}');
      throw e;
    }
  }

  Future<dynamic> postRequest(
      {String urlSuffix, var params, String authToken}) async {
        Map<String, String> headers;
    if (authToken != null) {
      headers = {
        "Content-type": "application/json",
        "Authorization": "bearer " + authToken
      };
    }
    try {
      final finalJson = jsonEncode(params);
      final response =
          await httpClient.post("$baseUrl/$urlSuffix", body: finalJson, headers: headers);
      return await _handleResponse(response);
    } catch (e) {
      print('error in post request $urlSuffix ${e.toString()}');
      throw e;
    }
      }

  Future<dynamic> _handleResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        Map<String, dynamic> jsonResponse = await json.decode(response.body);
        return (jsonResponse);

      case 400:
        throw BadRequestException(response.body.toString());

      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
        break;
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
