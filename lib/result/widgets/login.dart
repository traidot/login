import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kokoromil/constants.dart';
import 'package:kokoromil/result/widgets/result.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: scopes,
);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? _currentUser;

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      _currentUser = await _googleSignIn.signIn();

      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage("Email: ", _currentUser!.email)),
      );
    } catch (error) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage(error.toString(), "")),
      );
    }
  }

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
      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ResultPage("Email: ", credential.email.toString())),
      );
    } catch (error) {
      print(error);
    }
  }

  Future<void> _loginWithLine(BuildContext context) async {
    try {
      final result = await LineSDK.instance.login(scopes: ["openid", "email"]);
      final userEmail = result.accessToken.email;

      if (userEmail == null) {
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ResultPage("Email: ", "error")),
        );
      }
      // Check email
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultPage("Email: ", userEmail!)),
      );
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _loginWithFacebook(BuildContext context) async {
    print("Facebook login");

    try {
      // Create an instance of FacebookLogin
      final fb = FacebookLogin();

      // Log in
      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);

      // Check result status
      switch (res.status) {
        case FacebookLoginStatus.success:
          // Logged in

          // Send access token to server for validation and auth
          final FacebookAccessToken? accessToken = res.accessToken;
          print('Access token: ${accessToken?.token}');

          // Get profile data
          final profile = await fb.getUserProfile();
          print('Hello, ${profile?.name}! You ID: ${profile?.userId}');

          // Get user profile image url
          final imageUrl = await fb.getProfileImageUrl(width: 100);
          print('Your profile image: $imageUrl');

          // Get email (since we request email permission)
          final email = await fb.getUserEmail();
          // But user can decline permission
          if (email != null) print('And your email is $email');

          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultPage("Email: ", email!)),
          );

          break;
        case FacebookLoginStatus.cancel:
          // User cancel log in
          if (!context.mounted) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ResultPage("User cancel", "")));
          break;
        case FacebookLoginStatus.error:
          // Log in failed
          if (!context.mounted) return;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ResultPage("System error", "")));
          break;
      }
    } catch (error) {
      print(error);
      if (!context.mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ResultPage("System error", error.toString())));
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 16),
                  child: TextField(
                    controller:
                        TextEditingController(text: "example@gmail.com"),
                    obscureText: false,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide:
                            const BorderSide(color: boderColor, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(1.0),
                        borderSide:
                            const BorderSide(color: boderColor, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(1.0),
                        borderSide:
                            const BorderSide(color: boderColor, width: 2),
                      ),
                      labelText: "USERNAME",
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: mainColor),
                      hintText: "Enter Text",
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      filled: true,
                      fillColor: const Color(0x00ffffff),
                      isDense: false,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                  ),
                ),
                TextField(
                  controller: TextEditingController(text: "123456"),
                  obscureText: true,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    disabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                      borderSide: const BorderSide(color: boderColor, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                      borderSide: const BorderSide(color: boderColor, width: 2),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(1.0),
                      borderSide: const BorderSide(color: boderColor, width: 2),
                    ),
                    labelText: "PASSWORD",
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: mainColor,
                    ),
                    hintText: "Enter Text",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff000000),
                    ),
                    filled: true,
                    fillColor: const Color(0x00ffffff),
                    isDense: false,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password ?",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: mainColor,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  color: buttonColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.all(16),
                  textColor: buttonTitleColor,
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "OR",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: mainColor,
                      ),
                    ),
                  ),
                ),
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
                        height: 60,
                        child: MaterialButton(
                          onPressed: () {
                            _loginWithGoogle(context);
                          },
                          color: Colors.lightBlue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          padding: const EdgeInsets.all(16),
                          textColor: buttonTitleColor,
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width,
                          child: const Text(
                            "Sign in with Google",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                        height: 60,
                        child: MaterialButton(
                          onPressed: () {
                            _loginWithLine(context);
                          },
                          color: Colors.green,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          padding: const EdgeInsets.all(16),
                          textColor: buttonTitleColor,
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width,
                          child: const Text(
                            "LINEでログイン",
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
                        height: 50,
                        child: MaterialButton(
                          onPressed: () {
                            _loginWithFacebook(context);
                          },
                          color: Colors.blue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          padding: const EdgeInsets.all(16),
                          textColor: buttonTitleColor,
                          height: 50,
                          minWidth: MediaQuery.of(context).size.width,
                          child: const Text(
                            "Sign in with Facebook",
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
