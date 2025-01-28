import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../common_methods/oauth_methods.dart';
import '../constants/common_constants.dart';
import '../constants/key_constants.dart';
import '../preferences/preference_constants.dart';
import '../preferences/preference_helper.dart';
import 'api_urls_constants.dart';

class ApiHelper {
  //header for normal request
  var header = {'Accept': 'application/json', 'Authorization': ''};

  //header for json request
  var jsonHeader = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': ''
  };

  int reCallApi = 1;

  /*Future<dynamic> apiRequest(String url, Map<String, dynamic> map,
      {bool isShowProgress = true,
      bool showSnackBarIfError = true,
      bool get = false,
      BuildContext? context}) async {
    if (url != deviceRegisterUrl) {
      String clientSecret =
          await PreferenceHelper.getString(clientSecretPreferenceKey);
      map[clientSecretPreferenceKey] = clientSecret;
    }
    if (await OauthMethods.getLogin()) {
      OauthObject oauthObject = await OauthMethods.getOauthInPreference();
      jsonHeader['Authorization'] = 'Bearer ${oauthObject.accessToken}';
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    map[appVersionCodeKey] = packageInfo.buildNumber;
    map[applicationCodeKey] = applicationCode;

    showLog("Api req : $baseUrl$url");
    showLog("Header:$jsonHeader");
     showLog("Body:$map");
    final body = jsonEncode(map);
    showLog("encoded");
    try {
      var response = get != true
          ? await http.post(Uri.parse('$baseUrl$url'),
              headers: jsonHeader, body: body)
          : await http.get(Uri.parse('$url'),
              headers: jsonHeader, );
      showLog("Response : ${response.statusCode} \n ${response.body}");
      dynamic responseData = await processResponse(response, context);
      if (responseData == reCallApi) {
        return await apiRequest(
          url,
          map,
        );
      } else {
        return responseData;
      }
    } catch (e,s) {
      showLog("Response Error $e: $e");
    }
  }*/
  Future<dynamic> apiRequest(String url, Map<String, dynamic> map,
      {bool isShowProgress = true,
        bool showSnackBarIfError = true,
        bool get = false,
        BuildContext? context}) async {
    if (url != deviceRegisterUrl) {
      String clientSecret =
      await PreferenceHelper.getString(clientSecretPreferenceKey);
      map[clientSecretPreferenceKey] = clientSecret;
    }
    if (await OauthMethods.getLogin()) {
      OauthObject oauthObject = await OauthMethods.getOauthInPreference();
      jsonHeader['Authorization'] = 'Bearer ${oauthObject.accessToken}';
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    map[appVersionCodeKey] = applicationVersion;
    map[applicationCodeKey] = applicationCode;

    showLog("Api req : $baseUrl$url");
    showLog("Header:$jsonHeader");
    showLog("Body:$map");

    final body = jsonEncode(map);
    showLog("encoded");

    // Handle certificate bypass for development (not recommended for production)
    var client = CustomHttpClient.getClient(); // Use the custom client

    try {
      var response = get != true
          ? await client.post(Uri.parse('$baseUrl$url'),
          headers: jsonHeader, body: body)
          : await client.get(Uri.parse('$baseUrl$url'),
          headers: jsonHeader);
      showLog("Response : ${response.statusCode} \n ${response.body}");
      dynamic responseData = await processResponse(response, context);
      if (responseData == reCallApi) {
        return await apiRequest(
          url,
          map,
        );
      } else {
        return responseData;
      }
    } catch (e, s) {
      showLog("Response Error $e: $s");
      return null; // Return null or handle the error as needed
    }
  }

  dynamic processResponse(http.Response response, BuildContext? context) async {
    switch (response.statusCode) {
      case 200:
        {
          var responseJson = response.body;
          return responseJson;
        }
      case 201:
        {
          var responseJson = response.body;
          return responseJson;
        }
        break;
      case 422:
        {
          // statements;
        }
        break;
      case 426:
        {
          // update
          try {
            //AppUpdateController appUpdateController = AppUpdateController();
            //await appUpdateController.updateCheck(context);
          } catch (e) {
            showLog("there is an error in app update $e");
          }
        }
        break;
      case 401:
        {
          OauthObject oauthObject = await OauthMethods.getOauthInPreference();
          String clientSecret =
              await PreferenceHelper.getString(clientSecretKey);
          String applicationCode = '';
          /*if (Platform.isLinux) {
            applicationCode = applicationCodeLinux;
          } else if (Platform.isMacOS) {
            applicationCode = applicationCodeMac;
          } else if (Platform.isWindows) {
            applicationCode = applicationCodeWindows;
          }*/
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          Map<String, dynamic> map = {
            applicationCodeKey: applicationCode,
            appVersionCodeKey: applicationVersion,
            grantTypeKey: 'refresh_token',
            refreshTokenKey: oauthObject.refreshToken,
            clientSecretKey: clientSecret
          };
          List<int> compressedData = compressJson(map.toString());
          var response = await http.post(Uri.parse('$baseUrl$refreshTokenURL'),
              body: jsonEncode(map));
          if (response.statusCode == 200) {
            //RefreshToken refreshTokenResponse =
            // await compute(refreshTokenFromJson, response);
            //await OauthMethods.setOauthInPreference(OauthObject(
            //  expiresIn: refreshTokenResponse.expiresIn!,
            // refreshToken: refreshTokenResponse.refreshToken!,
            // accessToken: refreshTokenResponse.accessToken!));
            return reCallApi;
          } else {
            // logout and move to login page
          }
        }
        break;
      case 500:
        {
          // statements;
        }
        break;

      default:
        {
          //statements;
        }
        break;
    }
  }



  List<int> compressJson(String jsonData) {
    List<int> utf8Data = utf8.encode(jsonData);
    List<int> compressedData = gzip.encode(utf8Data);
    return compressedData;
  }
}

class CustomHttpClient {
  static http.Client getClient() {
    var ioClient = HttpClient();
    ioClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
  }
}