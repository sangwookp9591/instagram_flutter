import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

//storge class
class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //storage에 이미지 저장
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {

    Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    //post 이면?
    if ( isPost ) {
       String id = const Uuid().v1();
       print(id);
       ref = ref.child(id); // ?

    }
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL(); // 다운로드 url
    return downloadUrl;
  }
}