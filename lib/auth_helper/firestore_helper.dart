import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_miner_firebase/model/student_model.dart';

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

    firestore.collection(collection).add(data).then(
      (value) {
        log("Student added !!\nID: ${value.id}");
      },
    );
  }

  Future<List<Student>> getAllStudent() async {
    QuerySnapshot data = await firestore.collection(collection).get();

    List<QueryDocumentSnapshot> allData = data.docs;

    List<Student> allStudents =
        allData.map((e) => Student.fromMap(data: e.data() as Map)).toList();

    return allStudents;
  }

  Stream<QuerySnapshot> getDataStream() {
    return firestore.collection(collection).snapshots();
  }

  Future<int> getCounter() async {
    QuerySnapshot data = await firestore.collection(counter).get();

    List<QueryDocumentSnapshot> doc = data.docs;

    Map<String, dynamic> count = doc[0].data() as Map<String, dynamic>;

    int idCount = count['val'];

    log('Id count: $idCount');

    return idCount;
  }

  increaseId() async {
    int id = await getCounter();

    Map<String, dynamic> data = {
      'val': ++id,
    };

    firestore.collection(counter).doc('count').set(data);
  }

  getUser({required int id}) {
    return firestore.collection(collection).doc(toString()).snapshots();
  }

  getCredential({required int id}) async {
    DocumentSnapshot snapshot =
        await firestore.collection(collection).doc(id.toString()).get();
    Map userData = snapshot.data() as Map;
    return userData['password'];
  }
}
