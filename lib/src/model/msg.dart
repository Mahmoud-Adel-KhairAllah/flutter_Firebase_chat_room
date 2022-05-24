import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  late final String? id;
  late final String? email;
  late final String? chat;

  Chat({this.id, this.email, this.chat});

  Chat.fromSnapshot(snapshot)
      : id = snapshot.data()['id'],
        email = snapshot.data()['email'],
        chat = snapshot.data()['chat'];

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (email != null) "email": email,
      if (chat != null) "chat": chat,
    };
  }
}
