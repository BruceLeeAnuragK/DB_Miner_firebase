import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_miner_firebase/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class FireStoreHelper {
  FireStoreHelper._();
  Logger logger = Logger();
  static final FireStoreHelper storeHelper = FireStoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String collection = "User";
  static String colId = "Id";
  static String colUsername = "user_name";
  static String colDisplay = "display_name";
  static String colEmail = "email";
  static String colPassword = "password";
  static int colcontact = 0;
  addUser({required UserModel userModel}) async {
    Map<String, dynamic> data = {
      colId: userModel.displayname,
      colUsername: userModel.username,
      colEmail: userModel.email,
      colPassword: userModel.password,
    };
    logger.i(data);
    firestore
        .collection(collection)
        .doc((userModel.username).toString())
        .set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return firestore.collection(collection).snapshots();
  }

  // final ImagePicker _picker = ImagePicker();
  //
  // Future<void> _uploadFile() async {
  //   XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //
  //   if (image == null) return; // User canceled the operation
  //
  //   File file = File(image.path);
  //   Reference storageRef = _storage.ref().child('images/${DateTime.now()}.png');
  //
  //   UploadTask uploadTask = storageRef.putFile(file);
  //
  //   await uploadTask.whenComplete(() => print('File uploaded'));
  // }

  Future<void> deleteUser({required int id}) async {
    try {
      await firestore.collection(collection).doc(id.toString()).delete();
      logger.i('User with ID $id deleted successfully');
    } catch (error) {
      logger.e('Error deleting user: $error');
    }
  }

  Future<void> updateUser(
      {required int id, required UserModel updatedUserModel}) async {
    try {
      Map<String, dynamic> updatedData = {
        colId: updatedUserModel.displayname,
        colUsername: updatedUserModel.username,
        colEmail: updatedUserModel.email,
        colPassword: updatedUserModel.password,
      };

      await firestore
          .collection(collection)
          .doc(id.toString())
          .update(updatedData);
      logger.i('User with ID $id updated successfully');
    } catch (error) {
      logger.e('Error updating user: $error');
    }
  }

  //
  // Future resetEmail(String newEmail) async {
  //   var message;
  //   FireStoreHelper firebaseUser = await storeHelper.currentUser();
  //   firebaseUser
  //       .updateEmail(newEmail)
  //       .then(
  //         (value) => message = 'Success',
  //       )
  //       .catchError((onError) => message = 'error');
  //   return message;
  // }

  // updateEmail(String email) {}
  // final CollectionReference _usersCollection =
  //     FirebaseFirestore.instance.collection('users');
  // Future currentUser() async {
  //   try {
  //     UserModel? user = (await FirebaseAuth.instance.currentUser) as UserModel?;
  //     if (user != null) {
  //       DocumentSnapshot userDoc =
  //           await _usersCollection.doc(user.id as String?).get();
  //       if (userDoc.exists) {
  //         return user;
  //       } else {
  //         return null;
  //       }
  //     } else {
  //       return null;
  //     }
  //   } catch (error) {
  //     print('Error getting current user: $error');
  //     return null;
  //   }
  // }

  registerUser() {}
  final CollectionReference _credentialsCollection =
      FirebaseFirestore.instance.collection('credentials');

  Future<String?> getCredential({required int id}) async {
    try {
      DocumentSnapshot credentialDoc =
          await _credentialsCollection.doc(id.toString()).get();
      if (credentialDoc.exists) {
        return credentialDoc['password'];
      } else {
        return null;
      }
    } catch (error) {
      print('Error getting credential: $error');
      return null;
    }
  }
}
