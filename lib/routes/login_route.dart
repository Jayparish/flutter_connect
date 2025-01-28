import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:photomall_connect/commonWidgets/base_widget.dart';
import 'package:photomall_connect/commonWidgets/common_app_bar.dart';
import 'package:photomall_connect/commonWidgets/common_button.dart';
import 'package:photomall_connect/commonWidgets/common_text.dart';
import 'package:photomall_connect/routes/home_route.dart';

import '../constants/common_constants.dart';
import '../controllers/background_task_controller.dart';
import '../viewModel/login_view_model.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  BaseWidget<LoginViewModel>? baseWidget;

  @override
  Widget build(BuildContext context) {
    baseWidget = BaseWidget<LoginViewModel>(
      model: LoginViewModel(),
      onModelReady: (model) async {
        await model.getOtpSignature();
      },
      builder: (context, model, child) {
        return Scaffold(
            backgroundColor: const Color(photomallConnectBgColour),
            body: DoubleBackToCloseApp(
              snackBar: const SnackBar(
                content: Text('Press back again to exit the $appName app'),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/photomall_logo.png',
                      height: 140,
                    ),
                    //const Text( appName, style: TextStyle(color: Color(photomallConnectColour),fontSize: 25)),

                    Form(
                      key: model.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: TextFormField(style: const TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^(?:[+0]9)?[0-9]{10}$')
                                        .hasMatch(value!)) {
                                  return 'Enter a valid Number!';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              controller: model.mobileNumberController,
                              decoration:  InputDecoration(
                                labelText: 'Enter your Mobile Number',
                                labelStyle: const TextStyle(
                                    fontFamily: 'OpenSans', fontSize: 15,color: Colors.white),
                                //hintText: 'John Doe',
                                // prefixIcon: Icon(Icons.phone),
                                //suffixIcon: Icon(Icons.check_circle),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(photomallConnectLogoColour).withOpacity(.5), width: 2.0),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10.0)),
                                ),
                                errorText:
                                    null, // Set this to a string to display an error message
                              ),
                            ),
                          ),
                          !model.isLoading.value
                              ? CommonButton(
                                  onTap: () async {
                                    var number = model
                                        .mobileNumberController.text
                                        .replaceAll('+91', '');
                                    model.mobileNumberController.text = number;
                                    showLog('number login is $number');
                                    if (model.formKey.currentState!
                                        .validate()) {
                                      await model.userValidateApiCall(context,
                                          model.mobileNumberController.text);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Invalid mobile number: ${model.mobileNumberController.text}')));
                                    }
                                  },
                                  title: 'Login')
                              : const CircularProgressIndicator(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
    return baseWidget!;
  }
}
