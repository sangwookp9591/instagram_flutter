import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import '../models/user.dart';
/**
 * *extends :
    class 상속 선택구현, abstract class 면 상속 필수구현,
    다중상속 불가능
 *with : 상속 X, 기능을 가져오거나 오버라이드 가능
 * */
//store
// with -> 기능을 가져오거나 오버라이드 가능
/**
 * 접속 유저 정보를 web mobile 따로 가져오지 않기 위해 사용.
 * */
class UserProvider with ChangeNotifier{ //변경 알림 ,
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!; //getter

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    print(user);
    notifyListeners(); // user state 수정후 재렌더링 해주려면
  }

}