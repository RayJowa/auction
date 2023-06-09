
import 'package:auction/models/user.dart';
import 'package:auction/screens/shared/loading.dart';
import 'package:auction/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final _formKey = GlobalKey<FormState>();
  bool _loading = true;

  String firstName = '';
  String surname = '';
  String email = '';
  String phone = '';
  DateTime dob = DateTime(2000);


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

    return _loading ? const Loading() : Scaffold(
      appBar: AppBar(
        title: Text('User profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Update your profile'),
                  const SizedBox(height: 20,),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) {
                      setState(() {
                        firstName = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? 'Please enter surname' : null,
                    onChanged: (val) {
                      setState(() {
                        surname = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? 'Please enter email' : null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    validator: (val) => val!.isEmpty ? 'Please enter phone' : null,
                    onChanged: (val) {
                      setState(() {
                        phone = val;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(firstName);
                      }

                    },
                    child: Text('Update'),
                  )
                ],
              ),
            ),
          ],
        ),
      ) ,
    );
  }
}
