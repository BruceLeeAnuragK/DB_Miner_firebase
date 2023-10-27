import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_miner_firebase/model/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class FireStoreHelper {
  FireStoreHelper._();
  Logger logger = Logger();
  static final FireStoreHelper storeHelper = FireStoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String collection = "User";
  static String colId = "Id";
  static String colUsername = "username";
  static String colEmail = "email";
  static String colPassword = "password";
  addUser({required UserModel userModel}) async {
    Map<String, dynamic> data = {
      colId: userModel.id,
      colUsername: userModel.username,
      colEmail: userModel.email,
      colPassword: userModel.password,
    };
    logger.i(data);
    firestore.collection(collection).doc((userModel.id).toString()).set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return firestore.collection(collection).snapshots();
  }
}
