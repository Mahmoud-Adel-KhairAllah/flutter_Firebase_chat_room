import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  late final String? id;
  late final String? name;
  late final String? email;

  Person({
    this.id,
    this.name,
    this.email,
  });

  Person.fromSnapshot(snapshot)
      : id = snapshot.data()['id'],
        name = snapshot.data()['name'],
        email = snapshot.data()['email'];

  factory Person.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Person(
      id: data?['id'],
      name: data?['name'],
      email: data?['email'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (email != null) "email": email,
    };
  }
}
