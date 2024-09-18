import 'package:bazarapp/firebase_options.dart';
import 'package:bazarapp/pages/section1/1.splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

main()async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(MaterialApp(
    home:Splashscreen(),
    debugShowCheckedModeBanner: false,
  ),
  );
}