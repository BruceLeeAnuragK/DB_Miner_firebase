import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import "../model/student_model'.dart";

class FireStoreHelper {
  FireStoreHelper._();
  static final FireStoreHelper storeHelper = FireStoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collection = "Student";
  String counter = "Counter";

  String colId = "Id";
  String colName = "name";
  String colAge = "age";

  addStudent({required Student student}) {
    Map<String, dynamic> data = {
      colId: student.id,
      colName: student.name,
      colAge: student.age,
    };

    firestore.collection(collection).add(data).then((value) {
      log("Student added !!\nID: ${value.id}");
    });
  }

  Future<List<Student>> getAllStudent() async {
    QuerySnapshot data = await firestore.collection(collection).get();
    List<QueryDocumentSnapshot> allData = data.docs;
    List<Student> allStudent = allData
        .map(
          (e) => Student.fromMap(data: e.data() as Map),
        )
        .toList();
    return allStudent;
  }
}
