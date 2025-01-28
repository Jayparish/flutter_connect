import '../preferences/preference_constants.dart';
import '../preferences/preference_helper.dart';

class OauthMethods{

  static setLogin(bool value) async {
    await PreferenceHelper.setBool(isLoggedInPreferenceKey, value);
  }

  static Future<bool> getLogin() async {
    return await PreferenceHelper.getBool(isLoggedInPreferenceKey);
  }

  static setOauthInPreference(OauthObject oauthObject) async {
    await PreferenceHelper.setString(
        accessTokenPreferenceKey, oauthObject.accessToken);
    await PreferenceHelper.setString(
        refreshTokenPreferenceKey, oauthObject.refreshToken);
    await PreferenceHelper.setInt(
        accessTokenPreferenceExpiresKey, oauthObject.expiresIn);
  }

  static Future<OauthObject> getOauthInPreference() async {
    String accessToken =
    await PreferenceHelper.getString(accessTokenPreferenceKey);
    String refreshToken = await PreferenceHelper.getString(
      refreshTokenPreferenceKey,
    );
    int expires = await PreferenceHelper.getInt(
      accessTokenPreferenceExpiresKey,
    );
    return OauthObject(
      accessToken: accessToken,
      expiresIn: expires,
      refreshToken: refreshToken,
    );
  }
}

class OauthObject {
  String accessToken;
  String refreshToken;
  int expiresIn;

  OauthObject(
      {required this.accessToken,
        required this.refreshToken,
        required this.expiresIn});
}


