import 'dart:developer';

import 'package:db_miner_firebase/auth_helper/authhelper.dart';
import 'package:db_miner_firebase/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Login Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                bool login = await AuthHelper.authHelper.loginAnonymusly();
                if (login) {
                  Get.offNamed("/HomePage");
                }
              },
              child: Text("Anonymously Login"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool login = await AuthHelper.authHelper.registerUser(
                  email: "demo12@gmail.com",
                  password: "d1e2m3o4",
                );
              },
              child: Text("Register"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool login =
                    await AuthHelper.authHelper.loginWithUserNamePassword(
                  email: "demo12@gmail.com",
                  password: "d1e2m3o4",
                );
                if (login) {
                  Get.offNamed("/HomePage");
                }
              },
              child: Text("Sign in with Email Password"),
            ),
            ElevatedButton(
              onPressed: () async {
                GoogleSignInAccount? account =
                    await AuthHelper.authHelper.googleSignIn();

                if (account != null) {
                  log(" ###################################################name = ${account.displayName}");
                  UserModel user = UserModel();
                  user.username = account.displayName;
                  user.email = account.email;
                  user.image = account.photoUrl;
                  Get.offNamed("/HomePage", arguments: user);
                }
              },
              child: Text("Sign in with Google"),
            ),
          ],
        ),
      ),
    );
  }
}
