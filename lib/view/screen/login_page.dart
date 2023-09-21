import 'dart:developer';

import 'package:db_miner_firebase/auth_helper/authhelper.dart';
import 'package:db_miner_firebase/auth_helper/firestore_helper.dart';
import 'package:db_miner_firebase/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? psw;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Login Page",
          style: GoogleFonts.sofia(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onSubmitted: (val) async {
                    psw = await FireStoreHelper.storeHelper
                        .getCredential(id: int.parse(val));
                    log("PSW:  $psw");
                  },
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onSubmitted: (val) async {
                    if (psw == val) {
                      Get.snackbar(
                        "Success",
                        "Login done...",
                        colorText: Colors.green,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.snackbar(
                        "Failure",
                        "Password Mismatch",
                        colorText: Colors.red,
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                    psw = await FireStoreHelper.storeHelper
                        .getCredential(id: int.parse(val));
                    log("PSW:  $psw");
                  },
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () async {
                      bool login =
                          await AuthHelper.authHelper.loginAnonymusly();
                      if (login) {
                        Get.offNamed("/HomePage");
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(5, 5),
                        ),
                      ]),
                      child: Image.network(
                        "https://i.pinimg.com/564x/16/0e/44/160e44f4fa8a509958d2cb9fc46b5c16.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      GoogleSignInAccount? account =
                          await AuthHelper.authHelper.googleSignIn();

                      if (account != null) {
                        log(" ###################################################name = ${account.displayName}");
                        UserModel user = UserModel();
                        user.username = account.displayName;
                        user.email = account.email;
                        user.image = account.photoUrl;
                        Get.offNamed("/ChatPage", arguments: user);
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(5, 5),
                        ),
                      ]),
                      child: Image.network(
                          "https://i.pinimg.com/564x/39/21/6d/39216d73519bca962bd4a01f3e8f4a4b.jpg",
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
