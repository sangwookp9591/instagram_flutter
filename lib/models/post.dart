import 'package:cloud_firestore/cloud_firestore.dart';
//직렬화를 위한 class ->  자료 구조를 보다 읽기 쉬운 형태로 변환하는 과정
class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
    "description":description,
    "uid":uid,
    "username":username,
    "postId":postId,
    "datePublished":datePublished,
    "profImage":profImage,
    "likes":likes,
    "postUrl":postUrl,
  };

  //스냅샷을찍고 User모델 반환
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      likes : snapshot['likes'],
      postUrl : snapshot['postUrl'],
    );
  }
}