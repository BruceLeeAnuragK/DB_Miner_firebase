import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_miner_firebase/auth_helper/authhelper.dart';
import 'package:db_miner_firebase/auth_helper/firestore_helper.dart';
import 'package:db_miner_firebase/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = Get.arguments;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("${user?.name ?? 'Anonymous'} "),
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
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FireStoreHelper.storeHelper.getUser(username: '101'),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            List<QueryDocumentSnapshot>? docs =
                (snapShot.data as QuerySnapshot?)?.docs;

            if (docs != null) {
              List<Student> allStudents = docs
                  .map((doc) =>
                      Student.fromMap(data: doc.data() as Map<String, dynamic>))
                  .toList();

              int newId = allStudents.length + 101;
              return ListView.builder(
                itemCount: allStudents.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(allStudents[index].name),
                  subtitle: Text(allStudents[index].age.toString()),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController nameContoller = TextEditingController();
          TextEditingController ageContoller = TextEditingController();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add Student"),
              insetPadding: const EdgeInsets.all(10),
              content: Column(
                children: [
                  TextField(
                    controller: nameContoller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: ageContoller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton.icon(
                  onPressed: () {
                    Student student = Student(
                      id: 101,
                      name: nameContoller.text,
                      age: int.parse(ageContoller.text),
                    );

                    FireStoreHelper.storeHelper.addStudent(student: student);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Submit"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
