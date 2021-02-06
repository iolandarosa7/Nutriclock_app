import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:nutriclock_app/constants/constants.dart' as Constants;
import 'package:nutriclock_app/models/Drug.dart';
import 'package:nutriclock_app/models/Meal.dart';
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

  Future<http.Response> postWithAuth(
      Map<String, dynamic> data, String apiUrl) async {
    var url = Constants.BASE_API_URL + apiUrl;
    await _getToken();
    token = token.replaceAll("\"", "");
    return http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(data));
  }

  Future<http.Response> updateAvatar(String apiUrl, File file) async {
    var url = Constants.BASE_API_URL + apiUrl;
    await _getToken();
    token = token.replaceAll("\"", "");

    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var fileLenght = await file.length();
    var multipartFileSign = http.MultipartFile('avatar', stream, fileLenght,
          filename: basename(file.path));
    request.files.add(multipartFileSign);

    try {
      var streamedResponse = await request.send();
      var response = http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      rethrow;
    }

  }

  Future<http.Response> deletetWithAuth(String apiUrl, dynamic id) async {
    var url = Constants.BASE_API_URL + apiUrl + "/$id";
    await _getToken();
    token = token.replaceAll("\"", "");
    return http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
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
    request.fields['height'] = user.height.toString();
    request.fields['weight'] = user.weight.toString();

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

  Future<http.Response> postImageFormData(
      File file, String apiUrl, String type) async {
    var url = Constants.BASE_API_URL + apiUrl;

    await _getToken();
    token = token.replaceAll("\"", "");

    var request = http.MultipartRequest("POST", Uri.parse("$url"));

    request.headers['Accept'] = 'application/json';
    request.headers['Content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['type'] = type;

    var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    var fileLenght = await file.length();
    var multipartFileSign = http.MultipartFile('file', stream, fileLenght,
        filename: basename(file.path));
    request.files.add(multipartFileSign);

    try {
      var streamedResponse = await request.send();
      var response = http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> postMeal(Meal meal, File foodPhoto,
      File nutritionalInfoPhoto, int userId, String apiUrl) async {
    var url = Constants.BASE_API_URL + apiUrl;

    await _getToken();
    token = token.replaceAll("\"", "");

    var request = http.MultipartRequest("POST", Uri.parse("$url/$userId"));
    request.fields['name'] = meal.name;
    request.fields['quantity'] = meal.quantity;
    request.fields['relativeUnit'] = meal.relativeUnit;
    request.fields['type'] = meal.type;
    request.fields['date'] = meal.date;
    request.fields['time'] = meal.time;
    request.fields['observations'] = meal.observations;

    request.headers['Accept'] = 'application/json';
    request.headers['Content-type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    if (foodPhoto != null) {
      var stream =
          http.ByteStream(DelegatingStream.typed(foodPhoto.openRead()));
      var fileLenght = await foodPhoto.length();
      var multipartFileSign = http.MultipartFile(
          'foodPhoto', stream, fileLenght,
          filename: basename(foodPhoto.path));
      request.files.add(multipartFileSign);
    }

    if (nutritionalInfoPhoto != null) {
      var stream = http.ByteStream(
          DelegatingStream.typed(nutritionalInfoPhoto.openRead()));
      var fileLenght = await nutritionalInfoPhoto.length();
      var multipartFileSign = http.MultipartFile(
          'nutritionalInfoPhoto', stream, fileLenght,
          filename: basename(nutritionalInfoPhoto.path));
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
    print(token);
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
