import 'package:db_miner_firebase/auth_helper/firestore_helper.dart';
import 'package:db_miner_firebase/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  User? user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat page",
          style: GoogleFonts.sofia(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: StreamBuilder(
        stream: FireStoreHelper.storeHelper.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("###########${snapshot.data}");
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => const ListTile(
                title: Text("hi"),
                subtitle: Text(""),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
