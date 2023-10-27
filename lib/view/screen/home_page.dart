import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_miner_firebase/auth_helper/authhelper.dart';
import 'package:db_miner_firebase/auth_helper/firestore_helper.dart';
import 'package:db_miner_firebase/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/student_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: Builder(
          builder: (context) => MaterialButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            child: (user?.image?.isNotEmpty ?? false)
                ? CircleAvatar(
                    foregroundImage: NetworkImage("${user?.image}"),
                    radius: 20,
                  )
                : Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
          ),
        ),
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
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                radius: 30,
                foregroundImage: NetworkImage("${user?.image}"),
              ),
              accountName: Text("${user?.name ?? 'Anonymous'} "),
              accountEmail: Visibility(
                visible: user != null,
                child: Text("${user?.email ?? 'n0@gmail.com'}"),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FireStoreHelper.storeHelper.getUser(),
        builder: (context, snapShot) {
          log("${snapShot.data}");

          if (snapShot.hasData) {
            List<QueryDocumentSnapshot>? docs =
                (snapShot.data as QuerySnapshot?)?.docs;

            if (docs != null) {
              List<UserModel> allUser = docs
                  .map((doc) => UserModel.fromMap(
                      data: doc.data() as Map<String, dynamic>))
                  .toList();

              int newId = allUser.length + 101;
              return ListView.builder(
                itemCount: allUser.length,
                itemBuilder: (context, index) => Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (val) {},
                        icon: Icons.edit,
                        backgroundColor: Colors.blue,
                      ),
                      SlidableAction(
                        onPressed: (val) {
                          // FireStoreHelper.storeHelper
                          //     .deleteUser(id: allUser[index].id);
                        },
                        icon: Icons.delete,
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      leading: Text(allUser[index].id.toString()),
                      title: Text(allUser[index].username),
                      subtitle: Text(allUser[index].email.toString()),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text("no docs"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add User"),
        onPressed: () {
          TextEditingController nameContoller = TextEditingController();
          TextEditingController emailController = TextEditingController();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add Student"),
              insetPadding: const EdgeInsets.all(10),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: nameContoller.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: emailController.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
