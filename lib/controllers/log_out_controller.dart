

import 'package:flutter/material.dart';

import '../constants/route_paths_constants.dart';
import '../preferences/preference_constants.dart';
import '../preferences/preference_helper.dart';

class LogOutController{


  setLogOut(BuildContext context) async {
   await removeValues(context);
   Navigator.pop(context);
   Navigator.pushNamed(
     context,
     RoutePaths.login,
   );

  }

  removeValues(BuildContext context,) async {
   await PreferenceHelper.removePreference(accessTokenPreferenceKey);
   await PreferenceHelper.removePreference(refreshTokenPreferenceKey);
   await PreferenceHelper.removePreference(accessTokenPreferenceExpiresKey);
   await PreferenceHelper.removePreference(isLoggedInPreferenceKey);

  }


}