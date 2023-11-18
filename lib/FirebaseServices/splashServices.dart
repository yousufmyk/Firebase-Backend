import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebasebackend/ui/auth/loginScreen.dart';
import 'package:firebasebackend/ui/posts/upload_image.dart';

import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      // Timer(const Duration(seconds: 3), () =>Navigator.push( context, MaterialPageRoute(builder: (context)=> const PostScreen())));
      // Timer(
      //     const Duration(seconds: 3),
      //     () => Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => const FireStoreScreen())));

      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UploadImageScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    }
  }
}
