
import 'package:auction/models/user.dart';
import 'package:auction/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
   AuctionUser? _userFromFirebaseUser(User? user) {
     return user != null ? AuctionUser(uid: user.uid):null;
   }

   // auth change user stream
  Stream<AuctionUser?> get user {
     return _auth.authStateChanges()
         .map(_userFromFirebaseUser);
  }


  //sign in with email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
     try {
       UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
       User? user = credential.user;

       // //create new user profile with uid
       // await DatabaseService(uid: user!.uid).updateUserData('', '', '', DateTime(2000) );

       return _userFromFirebaseUser(user);
     } catch (e) {
       print(e.toString());
       return null;
     }
  }
  //sign in with phone number

  //sign in with facebook

  //sign in with google

  //sign out
  Future signOut() async {
     try {
       return await _auth.signOut();
     } catch (e) {
       print(e.toString());
     }
  }

}
