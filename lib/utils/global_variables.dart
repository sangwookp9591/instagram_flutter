import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';
import 'package:instagram_flutter/screens/search_screen.dart';
import '../screens/profile_screen.dart';
/**
 * global_variables.dart
 *
 * - 반응형 기준 SIze
 * - bottom navigation에서 pagging될 화면 List
 * */



/**반응형 기준 사이즈*/
const webScreenSize = 600; // 정해놓은 web screen -> mobile, web 구분

/**bottom navigation에서 pagging될 화면 List*/
List<Widget> homeScreenItems = [
  const FeedSceen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notif'),
  ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];