import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * 안타깝게도, jsonDecode()는 Map<String, dynamic>을 돌려주어, 런타임 이전까지는 값의 자료형을 알 수 없게 됩니다. 이런 접근 방식을 사용하면, 정적 타입 언어의 기능인 타입 안전성, 자동완성, 그리고 가장 중요한 컴파일 타임 오류를 사용할 수 없게 됩니다.
 * */
/**
 * 필드에 대해 타입 안전성, 자동완성, 컴파일 타임 예외처리가 가능
 * */
class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

/**
 * 모델 클래스에서 JSON 직렬화
 * toJson , fromSnap
 * */

  //User 객체를 map 구조로 변환하기 위한 메서드인 toJson() 메서드
  Map<String, dynamic> toJson() => {
    "username":username,
    "uid":uid,
    "email":email,
    "photoUrl":photoUrl,
    "bio":bio,
    "followers":followers,
    "following":following,
  };

  //firebase에서 snapshot으로 받은 데이터를 map 구조로 변경 후 새로운 User 객체를 생성하기 위한 생성자
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following : snapshot['following'],
    );
  }
}