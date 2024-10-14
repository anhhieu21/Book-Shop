import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  CollectionReference dBusers = FirebaseFirestore.instance.collection('users');

  Future<bool> checkAuthState() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final user = await dBusers.doc(userId).get();

      if (!user.exists) return false;

      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> signUp(
      {required String email,
      required String password,
      required String userName}) async {
    try {
      final response = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      dBusers.doc(response.user!.uid).set({
        'userName': userName,
        'email': email,
        'userId': response.user!.uid,
      });

      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> logout()async{
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseException {
      return false;
    }
  }
}
