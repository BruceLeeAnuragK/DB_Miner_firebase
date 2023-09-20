import 'package:db_miner_firebase/auth_helper/firestore_helper.dart';
import 'package:flutter/material.dart';

class PersonChatPage extends StatelessWidget {
  const PersonChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: StreamBuilder(
        //   stream:
        //       FireStoreHelper.storeHelper.getUserStream(userId: data['sender']),
        //   builder: (context, snapshot) => Column(),
        // ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
