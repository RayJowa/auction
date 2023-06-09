import 'package:auction/models/user.dart';
import 'package:auction/screens/authenticate/authenticate.dart';
import 'package:auction/screens/home/home.dart';
import 'package:auction/services/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuctionUser?>(context);

    //return either home or authenticate
    if (user == null) {
      return Authenticate();
    } else {
      return const Profile();
    }
  }
}
