import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemAddModel {
  final String? title;
  final String? price;
  final String? brand;
  final String? address;
  final String? decription;
  final String? urlImage;
  final String? email;

  ItemAddModel(
      {this.title,
      this.price,
      this.brand,
      this.address,
      this.decription,
      this.urlImage,
      this.email});
  Map<String, String> toMap() {
    return {
      "title": title!,
      "price": price!,
      "band": brand!,
      "Address": address!,
      "decription": decription!,
      "image": urlImage!,
      "email": email!,
    };
  }

  factory ItemAddModel.fromMap(map) {
    return ItemAddModel(
        title: map['title'],
        price: map['price'],
        brand: map['brand'],
        address: map['address'],
        decription: map['decription'],
        urlImage: map['urlImage'],
        email: map['email']);
  }
}

class OnlineStatus {
  String Status = "";
  void onlineStatus() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({"timeOfStatus": DateTime.now().toString()});
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStatus(String documentUri) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    return FirebaseFirestore.instance
        .collection('user')
        .doc(documentUri)
        .snapshots();
  }
}

OnlineStatus status = OnlineStatus();
