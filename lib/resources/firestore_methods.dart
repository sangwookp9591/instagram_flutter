import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

//store class
class FirestoreMethods {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  //upload post -> update
  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage,
      ) async {
    String res = "some error occured";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      await _store.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    }catch(e) {
      res = e.toString();
    }
    return res;
  }


  //게시물 좋아요
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) { //좋아요 취소
        await _store.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else { //좋아요
        await _store.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch(e) {
      print(e.toString(),);
    }

  }

  //게시물 댓글
  Future<void> postCommnet(String postId, String text, String uid, String name, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _store.collection('posts').doc(postId).collection('comments').doc(commentId).set({
              'profilePic': profilePic,
              'name':name,
              'uid':uid,
              'text':text,
              'commentId':commentId,
              'datePublished':DateTime.now(),
            });
      }else {
        print('Text is empty');
      }
    } catch(e) {
      print(e.toString(),);
    }
  }

  //게시물 삭제
  Future<void> deletePost(String postId) async {
    try {
      _store.collection('posts').doc(postId).delete();
    }catch(e) {
      print(e.toString());
    }
  }


  //팔로워 팔로잉
  Future<void> followUser(
      String uid,
      String followId
      ) async {
    print(uid);
    print(followId);
    try {
      //내가 following하는 사람들
      DocumentSnapshot snap = await _store.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      print(following.contains(followId));
      //내가 following 하는 사람이면
      if (following.contains(followId)) {
        //following하는 사람의 follower목록에서 삭제
        await _store.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        //내 following 목록에서 삭제
        await _store.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        //following하는 사람의 follower목록에 추가
        await _store.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        //내 following 목록에 추가
        await _store.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    }catch(e) {
      print(e.toString());
    }

  }
}