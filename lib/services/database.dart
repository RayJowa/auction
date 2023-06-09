import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('profiles');
  final CollectionReference itemCollection = FirebaseFirestore.instance.collection('Items');

  Future updateUserData(String firstName, String surname, String phoneNumber, DateTime? dob) async {
    return await userCollection.doc(uid).set({
      'firstName': firstName,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'dob': dob
    });
  }

  Future<DocumentSnapshot?> profile() async {
    try {
      return await userCollection.doc(uid).get();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future saveItem(
      String title,
      String description,
      String bidStartPrice,
      String reserve,
      String address,
      String phone,
      int picCount
      ) async {

    return await itemCollection.add({
      'title': title,
      'description': description,
      'bidStartPrice': int.parse(bidStartPrice),
      'reserve': int.parse(reserve),
      'address': address,
      'phone': phone,
      'picCount': picCount
    });


  }


}