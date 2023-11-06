// ignore_for_file: avoid_print, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kokoromil/constants.dart';
import 'package:kokoromil/result/widgets/result.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _loginWithApple(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print("credential");
      print(credential);
      print("authorizationCode");

      print(credential.authorizationCode);
      print("familyName");
      print(credential.familyName);
      print("givenName");
      print(credential.givenName);
      print("identityToken");
      print(credential.identityToken);
      print(credential.state);
      print(credential.toString());
      final email = credential.email;
      print("email");
      print(email);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Text('Sign in'),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        // height: 60,
                        child: MaterialButton(
                          onPressed: () {
                            _loginWithApple(context);
                          },
                          color: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          padding: const EdgeInsets.all(16),
                          textColor: buttonTitleColor,
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width,
                          child: const Text(
                            "Appleでサインイン",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
