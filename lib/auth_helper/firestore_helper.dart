import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_miner_firebase/model/student_model.dart';
import 'package:db_miner_firebase/model/user_model.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper storeHelper = FireStoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collection = "User";
  String counter = "Counter";

  String colId = "Id";
  String colName = "name";
  String colAge = "age";

  String colusername = "age";
  String colemail = "age";
  String colpassword = "age";

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

  addUser({required UserModel userModel}) {
    Map<String, dynamic> datas = {
      colId: userModel.id,
      colusername: userModel.username,
      colemail: userModel.email,
      colpassword: userModel.password,
    };
    firestore.collection(collection).doc(userModel.id.toString()).set(datas);
    // return firestore.collection(collection).add(datas).then((value) {
    //   log("User Added !!\n Username: ${value.id}");
    // });
  }

  getUser({required String username}) {
    firestore.collection(collection).doc(username.toString()).snapshots();
  }

  Future<List<Student>> getAllStudent() async {
    QuerySnapshot data = await firestore.collection(collection).get();

    List<QueryDocumentSnapshot> allData = data.docs;

    List<Student> allStudents =
        allData.map((e) => Student.fromMap(data: e.data() as Map)).toList();

    return allStudents;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDataStream() {
    return firestore.collection(collection).doc().snapshots();
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

  getCredential({required int id}) async {
    DocumentSnapshot snapshot =
        await firestore.collection(collection).doc(id.toString()).get();
    Map userData = snapshot.data() as Map;
    return userData['password'];
  }

  getChats({required int senderId, required int receivedId}) async {
    Map sender = await getUser(username: '${senderId}');
    Map senderChat = sender['sent']['$receivedId'];
    Map recievedChat = sender['recieved']['$receivedId'];
    Map chats = {
      'sent': senderChat,
      'recieved': senderChat,
    };
    return chats;
  }

  getUserStream({required int userId}) {
    return firestore.collection(collection).doc(userId.toString()).snapshots();
  }
}
