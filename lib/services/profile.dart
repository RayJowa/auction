
import 'package:auction/models/user.dart';
import 'package:auction/screens/home/home.dart';
import 'package:auction/screens/profile/user_profile.dart';
import 'package:auction/screens/shared/loading.dart';
import 'package:auction/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool _loading = true;

  Future<DocumentSnapshot?> fetchProfile(uid) async {
    DocumentSnapshot? userProfile = await DatabaseService(uid: uid).profile();
    setState(() {
      _loading = false;
    });
    return userProfile;
  }


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuctionUser?>(context);

    Future<DocumentSnapshot?> userProfile = fetchProfile(user!.uid);

    // if ( ) {
    //   return _loading ? const Loading() : UserProfile();
    //
    // }else{
    //   return _loading ? const Loading() : Home();
    // }
    // return either profile or home
    return Container();

  }
}

