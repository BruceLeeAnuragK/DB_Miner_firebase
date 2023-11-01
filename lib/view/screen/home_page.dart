import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_miner_firebase/auth_helper/authhelper.dart';
import 'package:db_miner_firebase/auth_helper/firestore_helper.dart';
import 'package:db_miner_firebase/controller/ObscureController.dart';
import 'package:db_miner_firebase/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  ObscureController seenController = Get.put(ObscureController());
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
                  itemBuilder: (context, index) {
                    UserModel userModel = allUser[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (val) {
                              UserModel user = userModel;

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Edit Student"),
                                  content: Column(
                                    children: [
                                      TextFormField(
                                        onChanged: (val) {
                                          user.username = val;
                                        },
                                        initialValue: userModel.username,
                                        decoration: InputDecoration(
                                          labelText: "Username",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      TextFormField(
                                        onChanged: (val) {
                                          user.email = val;
                                        },
                                        initialValue: userModel.email,
                                        decoration: InputDecoration(
                                          labelText: "Email",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      TextFormField(
                                        onChanged: (val) {
                                          user.password = val;
                                        },
                                        initialValue: userModel.password,
                                        decoration: InputDecoration(
                                          labelText: "Password",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: Icons.edit,
                            backgroundColor: Colors.blue,
                          ),
                          SlidableAction(
                            onPressed: (val) {},
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
                    );
                  });
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
          TextEditingController idcontroller = TextEditingController();
          TextEditingController usercontroller = TextEditingController();
          TextEditingController emailcontroller = TextEditingController();
          TextEditingController passcontroller = TextEditingController();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add Student"),
              insetPadding: const EdgeInsets.all(10),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: usercontroller.text,
                        decoration: const InputDecoration(
                          label: Text("Username"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: emailcontroller.text,
                        decoration: const InputDecoration(
                          label: Text("Email"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() {
                        return TextFormField(
                          obscureText: seenController.obscureText.value,
                          initialValue: passcontroller.text,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  seenController.showText();
                                },
                                icon: Icon(Icons.remove_red_eye_outlined)),
                            label: Text("Password"),
                            border: OutlineInputBorder(),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton.icon(
                  onPressed: () async {
                    UserModel userModel = UserModel(
                      id: int.parse(idcontroller.text),
                      username: usercontroller.text,
                      email: emailcontroller.text,
                      password: passcontroller.text,
                    );
                    FireStoreHelper.storeHelper.addUser(userModel: userModel);
                    Get.back();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Cancle"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
