import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        // future: AuthHelper.authHelper,
        builder: (context, snapShot) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController nameContoller = TextEditingController();
          TextEditingController ageContoller = TextEditingController();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Add Student"),
              insetPadding: EdgeInsets.all(10),
              content: Column(
                children: [
                  TextField(
                    controller: nameContoller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: ageContoller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [ElevatedButton(onPressed: () {}, child: TextField())],
            ),
          );
        },
      ),
    );
  }
}
