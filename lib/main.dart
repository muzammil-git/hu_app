import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('hi');
    returnUserObject();

  }

  void returnUserObject() async{
    var url = Uri.parse("https://jsonplaceholder.typicode.com/users");
    var response = await http.get(url);
    print("Response Status: ${response.statusCode}");
    // print("Response Body: ${response.body}");

    /// Converting string to json objects
    var list = jsonDecode(response.body) as List;

    ///Clearing list and then adding the business logic
    users.clear();
    users.addAll(list.map((e) => e["email"]));
    setState(() {});
  }

  var firstTextCtrl = TextEditingController();
  var users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 320,
              child: TextField(
                controller: firstTextCtrl,
                decoration: const InputDecoration(hintText: "Add your text"),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  print(firstTextCtrl.text);
                  setState(() {});
                },
                child: const Text("Show User Json")),
            const SizedBox(
              height: 30,
            ),
            const Text("See text"),
            Text("${firstTextCtrl.text}"),
            ElevatedButton(
                onPressed: () async {

                  var url = Uri.parse("https://jsonplaceholder.typicode.com/users");
                  var response = await http.get(url);
                  print("Response Status: ${response.statusCode}");
                  // print("Response Body: ${response.body}");

                  /// Converting string to json objects
                  var list = jsonDecode(response.body) as List;

                  ///Clearing list and then adding the business logic
                  users.clear();
                  users.addAll(list.map((e) => e["email"]));

                  print("$users");
                  // print(list.map((e) => e["username"]).toList());

                  ///Updates all the added items
                  setState(() {});
                },
                child: Text("Show User Json")),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () async{
                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                  
                  CollectionReference a = firestore.collection("users");

                  DocumentSnapshot data = await a.doc("1").get();
                  print(data.data());

                  
                },
                child: Text("Test Firebase")),

            const Text(
              "User Data",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      color: Colors.red[200],
                      child: Center(child: Text('${users[index]}')),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
