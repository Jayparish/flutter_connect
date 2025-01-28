import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:photomall_connect/commonWidgets/base_widget.dart';
import 'package:photomall_connect/commonWidgets/common_text.dart';
import 'package:photomall_connect/preferences/preference_helper.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../api/api_call.dart';
import '../common_methods/oauth_methods.dart';
import '../constants/common_constants.dart';
import '../constants/route_paths_constants.dart';
import '../controllers/splash_screen_view_model.dart';
import '../preferences/preference_constants.dart';
import '../utils/toast_utils.dart';

class LoginViewModel extends BaseObserver {
  @override
  void onInternetConnectionBack() {
    // TODO: implement onInternetConnectionBack
  }

  Api api = Api(null);
  var userNumber = '';
  TextEditingController mobileNumberController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String signature = '';
  OauthMethods oauthMethods = OauthMethods();
  ToastUtils toastUtils = ToastUtils();

  Duration get loginTime => const Duration(milliseconds: 2250);
  String? otp;
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a mobile number';
    }

    String pattern = r'^(?:[+0]9)?[0-9]{10}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Enter a valid mobile number';
    }

    return null;
  }

  userValidateApiCall(BuildContext context, String mobileNo) async {
    isLoading.value = true;
    notifyListeners();
    var response = await api.userValidateApiCall(
        username: mobileNumberController.text, otpSignature: signature);
    if (response != null) {
      showLog('response userValidateApiCall ${response.clientId}');
      if (response.clientId != null) {
        await PreferenceHelper.setString(
            clientIdPreferenceKey, response.clientId.toString());
        await getOtpPopUp(context, mobileNo,
            clientId: response.clientId.toString());
        isLoading.value = false;
        notifyListeners();
      } else {
        isLoading.value = false;
        notifyListeners();
        ToastUtils.getAlert(context, 'You cant login', Colors.red);
      }
    }
  }

  Future<void> getOtpSignature() async {
    userNumber = await getPhoneNumbers();
    mobileNumberController.text =
        userNumber.replaceAll('91', '').replaceAll('+', '');

    await PreferenceHelper.setString(staffNumberKey, userNumber);
    await SmsAutoFill().listenForCode;
    signature = await SmsAutoFill().getAppSignature;
    showLog('signature->$signature');
  }

  getOtpPopUp(
    BuildContext context,
    String mobileNo, {
    required String clientId,
  }) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CommonText(
                  text: 'Verification Code',
                  styleFor: 'title',
                ),
                const SizedBox(
                  height: 25,
                ),
                CommonText(
                  text: ' Enter otp send to \n      $mobileNo',
                  styleFor: 'body',
                ),
              ],
            ),
            content:  ValueListenableBuilder<bool>(
    valueListenable: isLoading,
    builder: (context, value, child) {
    return value
    ? const LinearProgressIndicator()
                : PinFieldAutoFill(
                    autoFocus: true,
                    decoration: UnderlineDecoration(
                      colorBuilder: const FixedColorBuilder(Colors.black),
                      textStyle: Theme.of(context).textTheme.titleLarge,
                    ),
                    currentCode: otp,
                    onCodeChanged: ((val) async {
                      showLog("otp filled...");
                      otp = val!;
                      if (val.length == otpLength) {

                        isLoading.value = true;
                        notifyListeners();
                        try {

                          var response = await api.otpApiCall(
                              clientId: clientId,
                              otp: otp!,
                              username: mobileNo);
                          if (response != null) {
                            await PreferenceHelper.setString(
                                staffNumberKey, mobileNo);

                            await OauthMethods.setLogin(true);
                            await OauthMethods.setOauthInPreference(OauthObject(
                                accessToken: response.accessToken!,
                                refreshToken: response.refreshToken!,
                                expiresIn: response.expiresIn!));
                            otp = '';

                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              RoutePaths.home,
                            );
                          }
                        } catch (e, s) {
                          showLog("the otp got some error while$e api $s");
                          otp = '';
                          isLoading.value = false;

                          notifyListeners();
                        }
                      }
                    }),
                    onCodeSubmitted: ((val) {
                      showLog('code submitted : $val');
                      isLoading.value = true;
                      notifyListeners();
                      otp = val;
                    }),
                    codeLength: otpLength,
                  );})

          );
        });
  }
}
