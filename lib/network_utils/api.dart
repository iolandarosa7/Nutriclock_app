import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:nutriclock_app/constants/constants.dart' as Constants;
import 'package:nutriclock_app/models/Drug.dart';
import 'package:nutriclock_app/models/User.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString(Constants.LOCAL_STORAGE_TOKEN_KEY);
  }

  Future<http.Response> postWithoutAuth(
      Map<String, String> data, String apiUrl) {
    var url = Constants.BASE_API_URL + apiUrl;
    return http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(data));
  }

  Future<http.Response> registerUser(User user, File avatar, String password,
      List<Drug> drugs, String apiUrl) async {
    var url = Constants.BASE_API_URL + apiUrl;

    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields['name'] = user.name;
    request.fields['email'] = user.email;
    request.fields['password'] = password;
    request.fields['gender'] = user.gender;
    request.fields['acceptTerms'] = '1';
    request.fields['diseases'] = user.diseases;
    request.fields['drugs'] = jsonEncode(drugs);
    request.fields['birthday'] = user.birthday;
    request.fields['ufc_id'] = user.ufc_id.toString();

    request.headers['Accept'] = 'application/json';

    if (avatar != null) {
      var stream = http.ByteStream(DelegatingStream.typed(avatar.openRead()));
      var fileLenght = await avatar.length();
      var multipartFileSign = http.MultipartFile('avatar', stream, fileLenght,
          filename: basename(avatar.path));
      request.files.add(multipartFileSign);
    }

    try {
      var streamedResponse = await request.send();
      var response = http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> getWithAuth(String apiUrl) async {
    var url = Constants.BASE_API_URL + apiUrl;
    await _getToken();
    token = token.replaceAll("\"", "");
    return await http.get(
      url,
      headers: <String, String>{
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
  }

  Future<http.Response> putWithAuth(
      Map<String, dynamic> data, String apiUrl, dynamic param) async {
    var url = Constants.BASE_API_URL + apiUrl;

    if (param != null) url += "/$param";
    await _getToken();
    token = token.replaceAll("\"", "");
    return http.put(url,
        headers: <String, String>{
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(data));
  }

  Future<http.Response> getWithoutAuth(String apiUrl) async {
    var url = Constants.BASE_API_URL + apiUrl;
    return await http.get(
      url,
      headers: <String, String>{
        'Content-type': 'application/json',
      },
    );
  }
}
