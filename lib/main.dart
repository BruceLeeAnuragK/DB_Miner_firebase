import 'package:db_miner_firebase/provider/chat_pageProvider.dart';
import 'package:db_miner_firebase/view/screen/chat_page.dart';
import 'package:db_miner_firebase/view/screen/home_page.dart';
import 'package:db_miner_firebase/view/screen/login_page.dart';
import 'package:db_miner_firebase/view/screen/person_chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChartProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialRoute: "/HomePage",
      getPages: [
        GetPage(name: "/", page: () => LoginPage()),
        GetPage(name: "/HomePage", page: () => HomePage()),
        GetPage(name: "/ChatPage", page: () => ChatPage()),
        GetPage(name: "/PersonChatPage", page: () => PersonChatPage()),
      ],
    );
  }
}
