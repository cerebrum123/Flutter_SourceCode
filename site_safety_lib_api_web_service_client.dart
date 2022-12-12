import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as Http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:site_safety/util/constant/constants.dart';
import 'package:site_safety/util/log.dart';
import 'package:site_safety/util/utils.dart';

enum HttpMethod { HTTP_GET, HTTP_POST, HTTP_PUT }

enum RequestBodyType { TYPE_XX_URLENCODED_FORMDATA, TYPE_JSON, TYPE_MULTIPART }

enum TokenType {
  TYPE_BASIC,
  TYPE_BEARER,
  TYPE_NONE,
  TYPE_DEVICE_TOKEN,
}

enum WebError {
  INTERNAL_SERVER_ERROR,
  ALREADY_EXIST,
  UNAUTHORIZED,
  INVALID_JSON,
  NOT_FOUND,
  UNKNOWN,
  BAD_REQUEST,
  FORBIDDEN
}

///this class handles api calls
class WebServiceClient {

  static const BASE_URL = "https://demo.sitesafetyplan.com/api/";

  /// login via email or phone
  static Future<dynamic> hitLoginUser(Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "login";
    var response;
    await _hitService(url, HttpMethod.HTTP_POST, RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
        TokenType.TYPE_NONE, fieldMap)
        .then((value) {
      response = value;
    }).catchError((onError){
      print(onError);
    }).timeout(Duration(seconds: 120),onTimeout: (){
      Log.d("login timeout $response");
    });
    return response;
  }

  /// sign up user
  static Future<dynamic> hitSignUp(Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "signup";
    var response;
    await _hitService(url, HttpMethod.HTTP_POST, RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
        TokenType.TYPE_NONE, fieldMap)
        .then((value) => {response = value});
    return response;
  }

  /// verify OTP of
  static Future<dynamic> verifyPhoneOTP(
      Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "verifyPhoneOtp";
    var response;
    await _hitService(
            url,
            HttpMethod.HTTP_POST,
            RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
            TokenType.TYPE_NONE,
            fieldMap)
        .then((value) => {response = value});
    return response;
  }

  /// reset Password of
  static Future<dynamic> resetPassword(Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "resetpwPro";
    var response;
    await _hitService(
            url,
            HttpMethod.HTTP_POST,
            RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
            TokenType.TYPE_NONE,
            fieldMap)
        .then((value) => {response = value});
    return response;
  }

  ///resend code again
  static Future<dynamic> resendCodeApi(
      Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "resendpin";
    var response;
    await _hitService(url, HttpMethod.HTTP_POST, RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
        TokenType.TYPE_NONE, fieldMap)
        .then((value) => {response = value});
    return response;
  }

  ///forgotPassword
  static Future<dynamic> forgotPasswordApi(
      Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "resetPassword";
    var response;
    await _hitService(url, HttpMethod.HTTP_POST, RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
        TokenType.TYPE_NONE, fieldMap)
        .then((value) => {response = value});
    return response;
  }


  /// mail list data
  static Future<dynamic> hitMailListItems(
      Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "mailData";
    var response;
    await _hitService(url, HttpMethod.HTTP_POST, RequestBodyType.TYPE_JSON,
        TokenType.TYPE_BASIC, fieldMap)
        .then((value) => {response = value});
    return response;
  }
  /// mail list data
  static Future<dynamic> hitNewMail(Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "compose_pro";
    var response;
    await _hitService(
            url,
            HttpMethod.HTTP_POST,
            RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
            TokenType.TYPE_BASIC,
            fieldMap)
        .then((value) => {response = value});
    return response;
  }

  /// mail delete
  static Future<dynamic> hitDeleteMail(Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "delete_mail";
    var response;
    await _hitService(
            url,
            HttpMethod.HTTP_POST,
            RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
            TokenType.TYPE_BASIC,
            fieldMap)
        .then((value) => {response = value});
    return response;
  }

  /// mail reply
  static Future<dynamic> hitReplyMail(Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "reply";
    var response;
    await _hitService(
            url,
            HttpMethod.HTTP_POST,
            RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
            TokenType.TYPE_BASIC,
            fieldMap)
        .then((value) => {response = value});
    return response;
  }

  /// mail details
  static Future<dynamic> hitDetailMail(
      Map<String, dynamic> fieldMap, String id) async {
    var url = BASE_URL + "view_mail/$id";
    var response;
    await _hitService(
            url,
            HttpMethod.HTTP_GET,
            RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
            TokenType.TYPE_BASIC,
            fieldMap)
        .then((value) => {response = value});
    return response;
  }

  /// mail details
  static Future<dynamic> hitDetailProfile(Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "user_profile_detail";
    var response;
    await _hitService(
            url,
            HttpMethod.HTTP_GET,
            RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
            TokenType.TYPE_BASIC,
            fieldMap)
        .then((value) => {response = value});
    return response;
  }

  /// profile Image
  static Future<dynamic> hitImageProfile(
      Map<String, dynamic> fieldMap, Map<String, File> file) async {
    var url = BASE_URL + "edit_image";
    var response;
    await _hitService(url, HttpMethod.HTTP_POST, RequestBodyType.TYPE_MULTIPART,
            TokenType.TYPE_NONE, fieldMap,
            files: file)
        .then((value) => {response = value});
    return response;
  }

  /// user list data
  static Future<dynamic> hitUserList(Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "get_usernames";
    var response;
    await _hitService(
            url,
            HttpMethod.HTTP_POST,
            RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
            TokenType.TYPE_NONE,
            fieldMap)
        .then((value) => {response = value});
    return response;
  }

  /// add new items
  static Future<dynamic> hitAddNewItems(Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "module_name";
    var response;
    await _hitService(
            url,
            HttpMethod.HTTP_GET,
            RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
            TokenType.TYPE_NONE,
            fieldMap)
        .then((value) => {response = value});
    print(response);
    print("response");
    return response;
  }

  /// dashboard data
  static Future<dynamic> hitDashboardApi(Map<String, dynamic> fieldMap) async {
    var url = BASE_URL + "dashboard_data";
    var response;
    await _hitService(
            url,
            HttpMethod.HTTP_POST,
            RequestBodyType.TYPE_XX_URLENCODED_FORMDATA,
            TokenType.TYPE_BASIC,
            fieldMap)
        .then((value) => {response = value});
    return response;
  }

  ///this method will actually hit the service based on method(GET,PUT,POST
  static Future<dynamic> _hitService(String url, HttpMethod method,
      RequestBodyType type, TokenType tokenType, Map<String, dynamic> fieldMap,
      {Map<String, File> files}) async {
    if (await Utils.checkInternet()) {
      var response;
      var headerMap = Map<String, String>();
      if (tokenType == TokenType.TYPE_BASIC) {
        var sp = await SharedPreferences.getInstance();
        var token = sp.getString(PREF_TOKEN);
        Log.d("$token");
        // var deviceToken = sp.getString(DEVICE_TOKEN);

        // headerMap['fcm_token'] = deviceToken;
        // headerMap['device_type'] = Platform.isIOS?"ios":"android";
        headerMap["authorization"] = "Bearer $token" ?? "";
        //headerMap["authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFhcm9uMDcwMkBtYWlsaW5hdG9yLmNvbSIsInVzZXJfaWQiOiI1IiwiY3JlYXRlZF9ieV9zdWJzY3JpYmVyIjoiMCIsInVzZXJfcm9sZSI6IjI2IiwibmV3X2NyZWF0ZWRfYnkiOm51bGwsImFsbCI6eyJJRCI6IjUiLCJlbWFpbCI6ImFhcm9uMDcwMkBtYWlsaW5hdG9yLmNvbSIsInBhc3N3b3JkIjoiJDJhJDEyJGRrc1ZwamxlUlJad2F6ekpRWHJJMi53YjdLckN0eWZHSDNiUWEubEQwdHZITlYyZDhJM2thIiwidG9rZW4iOiJkYTVkNGI5ZmNhMDU4MDNhYjliZjY3M2IyYTRkMjdlNyIsIklQIjoiOTYuNDEuMTIyLjEwNyIsInVzZXJuYW1lIjoiQWFyb24wNzAyIiwiZmlyc3RfbmFtZSI6IkFhcm9uIiwibGFzdF9uYW1lIjoiU21pdGgiLCJhdmF0YXIiOiI1Y2I1Y2JjNGI0YWJhOGFhM2YxMDY0NWVkODQ3YTFiYy5wbmciLCJqb2luZWQiOiIxNjI1MjcwODE2Iiwiam9pbmVkX2RhdGUiOiI3LTIwMjEiLCJvbmxpbmVfdGltZXN0YW1wIjoiMTYzODUxMzI3NCIsIm9hdXRoX3Byb3ZpZGVyIjoiIiwib2F1dGhfaWQiOiIiLCJvYXV0aF90b2tlbiI6IiIsIm9hdXRoX3NlY3JldCI6IiIsImVtYWlsX25vdGlmaWNhdGlvbiI6IjEiLCJhYm91dG1lIjoiIiwicG9pbnRzIjoiMC4wMCIsInByZW1pdW1fdGltZSI6IjAiLCJ1c2VyX3JvbGUiOiIyNiIsImFzc2lnbmVkX3JvbGUiOiIwIiwic2VuZGVyX2lkIjoiMCIsInVzZXJfdHlwZSI6IjEiLCJzdWJzY3JpcHRpb25faWQiOiIxIiwicHJpY2VfaWQiOm51bGwsInN1YnNjcmlwdGlvbl9zdGF0dXMiOiJhY3RpdmUiLCJwcmVtaXVtX3BsYW5pZCI6IjAiLCJub3RpX2NvdW50IjoiOCIsImVtYWlsX2NvdW50IjoiMTEiLCJhY3RpdmVfcHJvamVjdGlkIjoiMCIsInRpbWVyX2NvdW50IjoiMCIsInRpbWVfcmF0ZSI6IjAuMDAiLCJwYXlwYWxfZW1haWwiOiIiLCJhZGRyZXNzXzEiOiIiLCJhZGRyZXNzXzIiOiIiLCJjaXR5IjoiIiwic3RhdGUiOiIiLCJ6aXBjb2RlIjoiIiwiY291bnRyeSI6IiIsImFjdGl2ZSI6IjEiLCJpc0VtYWlsVmVyaWZpZWQiOiIxIiwiYWN0aXZhdGVfY29kZSI6IiIsInN0cmlwZV9zZWNyZXRfa2V5IjoiIiwic3RyaXBlX3B1Ymxpc2hfa2V5IjoiIiwiY2hlY2tvdXQyX2FjY291bnRubyI6IjAiLCJjaGVja291dDJfc2VjcmV0IjoiIiwiY3JlYXRlZF9ieSI6bnVsbCwicmVxdWVzdGVkX2J5IjoiMCIsIm5ld19jcmVhdGVkX2J5IjpudWxsLCJjcmVhdGVkX2J5X3N1YnNjcmliZXIiOiIwIiwiZXhwaXJlX2RhdGUiOiIyMDIxLTA3LTE3IDEyOjA2OjU2IiwiY29tcGFueUlEIjoiMyIsImNvbXBhbnlfc3RhdHVzIjoiMSIsImNvbXBhbnlfcGhvbmUiOiI1NjIgMTIzLTQ1NjciLCJ0ZXJtIjoiMSIsImlzX2RlbGV0ZSI6IjAiLCJwcmV2aW91c19wbGFuIjpudWxsLCJ0aW1lX3pvbmUiOiJBbWVyaWNhXC9Mb3NfQW5nZWxlcyJ9LCJpYXQiOjE2Mzg1MTM1MTAsImV4cCI6MTYzODYwMDAxMH0.K8ymwJmoKRJCTl0HUzhdbu8IfmvGZT8rMqQho8gTHR8" ?? "";
      } else {
        var sp = await SharedPreferences.getInstance();
        var token = await sp.get(PREF_TOKEN);
        //  var deviceToken = await sp.getString(DEVICE_TOKEN);
        // headerMap['fcm_token'] = deviceToken;
        // headerMap['device_type'] = Platform.isIOS?"ios":"android";

        headerMap["authorization"] = "Bearer $token" ?? "";
        //headerMap["authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFhcm9uMDcwMkBtYWlsaW5hdG9yLmNvbSIsInVzZXJfaWQiOiI1IiwiY3JlYXRlZF9ieV9zdWJzY3JpYmVyIjoiMCIsInVzZXJfcm9sZSI6IjI2IiwibmV3X2NyZWF0ZWRfYnkiOm51bGwsImFsbCI6eyJJRCI6IjUiLCJlbWFpbCI6ImFhcm9uMDcwMkBtYWlsaW5hdG9yLmNvbSIsInBhc3N3b3JkIjoiJDJhJDEyJGRrc1ZwamxlUlJad2F6ekpRWHJJMi53YjdLckN0eWZHSDNiUWEubEQwdHZITlYyZDhJM2thIiwidG9rZW4iOiJkYTVkNGI5ZmNhMDU4MDNhYjliZjY3M2IyYTRkMjdlNyIsIklQIjoiOTYuNDEuMTIyLjEwNyIsInVzZXJuYW1lIjoiQWFyb24wNzAyIiwiZmlyc3RfbmFtZSI6IkFhcm9uIiwibGFzdF9uYW1lIjoiU21pdGgiLCJhdmF0YXIiOiI1Y2I1Y2JjNGI0YWJhOGFhM2YxMDY0NWVkODQ3YTFiYy5wbmciLCJqb2luZWQiOiIxNjI1MjcwODE2Iiwiam9pbmVkX2RhdGUiOiI3LTIwMjEiLCJvbmxpbmVfdGltZXN0YW1wIjoiMTYzODUxMzI3NCIsIm9hdXRoX3Byb3ZpZGVyIjoiIiwib2F1dGhfaWQiOiIiLCJvYXV0aF90b2tlbiI6IiIsIm9hdXRoX3NlY3JldCI6IiIsImVtYWlsX25vdGlmaWNhdGlvbiI6IjEiLCJhYm91dG1lIjoiIiwicG9pbnRzIjoiMC4wMCIsInByZW1pdW1fdGltZSI6IjAiLCJ1c2VyX3JvbGUiOiIyNiIsImFzc2lnbmVkX3JvbGUiOiIwIiwic2VuZGVyX2lkIjoiMCIsInVzZXJfdHlwZSI6IjEiLCJzdWJzY3JpcHRpb25faWQiOiIxIiwicHJpY2VfaWQiOm51bGwsInN1YnNjcmlwdGlvbl9zdGF0dXMiOiJhY3RpdmUiLCJwcmVtaXVtX3BsYW5pZCI6IjAiLCJub3RpX2NvdW50IjoiOCIsImVtYWlsX2NvdW50IjoiMTEiLCJhY3RpdmVfcHJvamVjdGlkIjoiMCIsInRpbWVyX2NvdW50IjoiMCIsInRpbWVfcmF0ZSI6IjAuMDAiLCJwYXlwYWxfZW1haWwiOiIiLCJhZGRyZXNzXzEiOiIiLCJhZGRyZXNzXzIiOiIiLCJjaXR5IjoiIiwic3RhdGUiOiIiLCJ6aXBjb2RlIjoiIiwiY291bnRyeSI6IiIsImFjdGl2ZSI6IjEiLCJpc0VtYWlsVmVyaWZpZWQiOiIxIiwiYWN0aXZhdGVfY29kZSI6IiIsInN0cmlwZV9zZWNyZXRfa2V5IjoiIiwic3RyaXBlX3B1Ymxpc2hfa2V5IjoiIiwiY2hlY2tvdXQyX2FjY291bnRubyI6IjAiLCJjaGVja291dDJfc2VjcmV0IjoiIiwiY3JlYXRlZF9ieSI6bnVsbCwicmVxdWVzdGVkX2J5IjoiMCIsIm5ld19jcmVhdGVkX2J5IjpudWxsLCJjcmVhdGVkX2J5X3N1YnNjcmliZXIiOiIwIiwiZXhwaXJlX2RhdGUiOiIyMDIxLTA3LTE3IDEyOjA2OjU2IiwiY29tcGFueUlEIjoiMyIsImNvbXBhbnlfc3RhdHVzIjoiMSIsImNvbXBhbnlfcGhvbmUiOiI1NjIgMTIzLTQ1NjciLCJ0ZXJtIjoiMSIsImlzX2RlbGV0ZSI6IjAiLCJwcmV2aW91c19wbGFuIjpudWxsLCJ0aW1lX3pvbmUiOiJBbWVyaWNhXC9Mb3NfQW5nZWxlcyJ9LCJpYXQiOjE2Mzg1MTM1MTAsImV4cCI6MTYzODYwMDAxMH0.K8ymwJmoKRJCTl0HUzhdbu8IfmvGZT8rMqQho8gTHR8" ?? "";
      }
      switch (method) {
        case HttpMethod.HTTP_GET:
          {
            Log.d("Sending Request:: GET $url headers $headerMap");
            response = await Http.get(Uri.parse(url), headers: headerMap);
          }
          break;
        case HttpMethod.HTTP_POST:
          {
            if (type == RequestBodyType.TYPE_XX_URLENCODED_FORMDATA) {
              headerMap["Content-Type"] = "application/x-www-form-urlencoded";
              Log.d("Sending Request:: POST $url body $fieldMap");
              response = await Http.post(Uri.parse(url),
                  headers: headerMap,
                  body: fieldMap,
                  encoding: convert.Utf8Codec());
            } else if (type == RequestBodyType.TYPE_MULTIPART) {
              headerMap["Content-Type"] = "multipart/form-data";
              var request = Http.MultipartRequest("POST", Uri.parse(url));
              if (fieldMap != null) {
                Map<String, String> map = fieldMap.cast<String, String>();
                request.fields.addAll(map);
              }
              print("file null or not >>>>>> $files");
              if (files != null && files.isNotEmpty) {
                files.forEach((key, file) async {
                  Http.MultipartFile multipartFile =
                      await Http.MultipartFile.fromPath(key, file.path,
                          contentType: file.path.endsWith("*.png")
                              ? MediaType('image', 'x-png')
                              : MediaType('image', 'jpeg'));
                  debugPrint(
                      "file is ${multipartFile.contentType} ${multipartFile.filename} ${multipartFile.length}");
                  request.files.add(multipartFile);
                });
              }
              request.headers.addAll(headerMap);
              response = await request.send();
            } else {
              // headerMap["Content-Type"] = "application/json";
              var json = convert.jsonEncode(fieldMap);
              Log.d(
                  "Sending Request json :: POST $url body $json map $headerMap");
              response =
              await Http.post(Uri.parse(url), headers: headerMap, body: json);
            }
          }
          break;
        case HttpMethod.HTTP_PUT:
          if (type == RequestBodyType.TYPE_XX_URLENCODED_FORMDATA) {
            headerMap["Content-Type"] = "application/x-www-form-urlencoded";
            Log.d("Sending Request:: PUT $url body $fieldMap");
            response = await Http.put(Uri.parse(url),
                headers: headerMap,
                body: fieldMap,
                encoding: convert.Utf8Codec());
          } else if (type == RequestBodyType.TYPE_MULTIPART) {
            headerMap["Content-Type"] = "multipart/form-data";
            var request = await Http.MultipartRequest("PUT", Uri.parse(url));
            Map<String, String> map = fieldMap.cast<String, String>();
            request.fields.addAll(map);
            if (files != null && files.isNotEmpty) {
              files.forEach((key, file) async {
                Http.MultipartFile multipartFile =
                    await Http.MultipartFile.fromPath(
                  key,
                  file.path,
                );
                request.files.add(multipartFile);
              });
            }
            request.headers.addAll(headerMap);
            response = await request.send();
          } else {
            headerMap["Content-Type"] = "application/json";
            var json = convert.jsonEncode(fieldMap);
            Log.d("Sending Request:: PUT $url body $json");
            response =
                await Http.put(Uri.parse(url), headers: headerMap, body: json);
          }
          break;
      }
      var statusCode = response.statusCode;
      Log.d("Response Code  :: $statusCode");
      Log.d("Response  :: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (type == RequestBodyType.TYPE_MULTIPART) {
          var res = await Http.Response.fromStream(response);
          Log.d("Response is :: " + res.body);
          return res.body;
        } else
          Log.d("Response is :: " + response.body);
        return response.body;
      } else {
        switch (response.statusCode) {
          case 400:
            return WebError.BAD_REQUEST;
            break;
          case 403:
            return WebError.BAD_REQUEST;
            break;
          case 500:
            return WebError.INTERNAL_SERVER_ERROR;
            break;
          case 404:
            return WebError.NOT_FOUND;
            break;
          case 401:
            return WebError.UNAUTHORIZED;
            break;
          case 409:
            return WebError.ALREADY_EXIST;
            break;
          default:
            return WebError.UNKNOWN;
            break;
        }
      }
    } else {
      return WebError.INTERNAL_SERVER_ERROR;
    }
  }
}

