import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  //user_provider와 연관
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _store.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
    // return model.User(
    //   followers: (snap.data() as Map<String, dynamic>)['followers']
    // );
  }

  //회원가입
  Future<String> signUpUser({
      required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty){
        //register user

        //Auth 등록후 crendetial 반환
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print('test');
        print(cred.user!.uid);

        String photoUrl =await StorageMethods().uploadImageToStorage('profilePics',file,false);


        model.User user = model.User(
              username: username,
              uid: cred.user!.uid,
              email: email,
              bio: bio,
              followers: [],
              following: [],
              photoUrl:photoUrl,
        );
        //유저 추가
        await _store.collection('users').doc(cred.user!.uid).set(user.toJson(),);

        res = "success";
      }
    } on FirebaseAuthException catch(error){ //firebase 관련 에러
      if (error.code == 'invalid-mail') { //flutter: [firebase_Auth/invalid-email]
        res = 'The email is badly formatted.';
      } else if (error.code =='weak-password') {//flutter: [firbase_auth/weak-password]
        res = 'password should be at least 6 characters';
      }
    }
    return res;

  }

  //로그인
  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String res = "Some error occurred";

    try {
        if (email.isNotEmpty || password.isNotEmpty){
          UserCredential cred =await _auth.signInWithEmailAndPassword(email: email, password: password);
          res ="success";
        }
    } on FirebaseAuthException catch(error) {
      if (error.code == 'user-not-found') {
        res = "user not found";
      }else if(error.code == 'wrong-password') {
        res = "wrong password ! ";
      }
      res = error.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}