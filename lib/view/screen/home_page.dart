import 'package:db_miner_firebase/auth_helper/authhelper.dart';
import 'package:db_miner_firebase/auth_helper/firestore_helper.dart';
import 'package:db_miner_firebase/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? user = Get.arguments;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("${user?.username ?? 'Anonymous'} "),
              accountEmail: Visibility(
                visible: user != null,
                child: Text("${user?.email ?? 'n0@gmail.com'}"),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "Home Page",
          style: GoogleFonts.sofia(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              AuthHelper.authHelper.signOut();
              Get.offNamed('/');
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: FireStoreHelper.storeHelper.getAllStudent(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return ListView.builder(
              itemCount: snapShot.data!.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(snapShot.data![index].name),
                subtitle: Text(snapShot.data![index].age),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController nameContoller = TextEditingController();
          TextEditingController ageContoller = TextEditingController();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Add Student"),
              insetPadding: EdgeInsets.all(10),
              content: Column(
                children: [
                  TextField(
                    controller: nameContoller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: ageContoller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [ElevatedButton(onPressed: () {}, child: TextField())],
            ),
          );
        },
      ),
    );
  }
}
