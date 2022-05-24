import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_final/src/model/user.dart';
import 'package:flutter_application_final/src/screens/login.dart';

import '../model/msg.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  CollectionReference chats = FirebaseFirestore.instance.collection("chats");
  List<Chat> _chats = [];
  late String _chat = "";
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    var data = await FirebaseFirestore.instance.collection("chats").get();
    print(data.docs);
    setState(() {
      _chats = List.from(data.docs.map((doc) => Chat.fromSnapshot(doc)));
      _chats.reversed;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Home'), actions: [
        IconButton(
            onPressed: () {
              auth.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: ((context) => LoginScreen())),
              );
            },
            icon: Icon(Icons.logout))
      ]),
      body: Container(
        padding: EdgeInsets.all(0),
        width: double.infinity,
        //margin: EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        //  constraints: BoxConstraints(maxWidth: 100),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
                child: Container(
                    child: RefreshIndicator(
              onRefresh: () async {
                didChangeDependencies();
              },
              child: ListView.builder(
                  itemCount: _chats.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          _chats[index].chat.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    );
                  })),
            ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: TextField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      hintText: 'Chat',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onChanged: (value) {
                    setState(() {
                      _chat = value.trim();
                    });
                  },
                )),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).accentColor,
                    child: Text('Send'),
                    onPressed: () {
                      setState(() {
                        String? id =
                            auth.currentUser?.uid.toLowerCase().toString();
                        String? email = auth.currentUser?.email.toString();
                        Chat chat = new Chat(id: id, email: email, chat: _chat);
                        _chats.add(chat);
                        chats.doc().set(chat.toFirestore());
                        _chat = "";
                      });
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget cardui() {
  return Card(
    margin: EdgeInsets.all(15),
    color: Colors.amber,
    child: Column(
      children: <Widget>[
        Text("name"),
        SizedBox(
          height: 5,
        ),
        Text("email")
      ],
    ),
  );
}
