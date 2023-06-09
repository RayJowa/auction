import 'package:auction/screens/home/add_item.dart';
import 'package:auction/screens/home/list_item.dart';
import 'package:auction/screens/home/post_item.dart';
import 'package:auction/screens/wrapper.dart';
import 'package:auction/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auction/models/user.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuctionUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: ListItem(),
      ),
    );
  }
}


