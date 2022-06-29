import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/utils/colors.dart';

void main() async{
  /**
   * Flutter는 main 메소드를 앱의 시작점으로 사용합니다.
   * main 메소드에서 서버나 SharedPreferences 등 비동기로 데이터를 다룬 다음 runApp을 실행해야하는 경우 아래 한줄을 반드시 추가해야합니다.
   * */
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /**
     * 스트림은 데이터나 이벤트가 들어오는 통로입니다.
        앱을 만들다 보면 데이터를 처리할 일이 많은데, 어느 타이밍에 데이터가 들어올지 확실히 알기 어렵습니다.
        스트림은 이와 같은 비동기 작업을 할 때 주로 쓰인다.
        앱 환경에서 데이터를 지속적으로 받고 보내야하는 상황은 되게 많다. 동기적으로나 비동기적으로 이벤트를 듣고 있는걸 stream이라고 한다.
        stream을 연결해 놓으면 이벤트를 주기적으로 확인할 필요없이 stream이 업데이트가 발생할때 알림을 준다.
     * */
    Stream<User?> id = FirebaseAuth.instance.idTokenChanges();
    print(id);
    /**state 보관함
     *
     * 이 state 쓰고 싶은 위젯들을 전부 ChangeNotifierProvider()로 감싸야함.
     * 거의 모든 widget이 사용한다 그러면 MeterailApp에 감싸주자!\\
     *
     * Provider 사용법
     * 1. store 만들고
     * 2. store에 쓸 위젯들 등록
     * 3. store에 있던거 쓸때는
     * context.watch<Storename>()-> state각각 출력 , read함수 실행 */
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UserProvider())

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //위젯을 커스텀하다 보면 변경하고 싶은 속성값은 1개뿐인데, 모든 속성값을 입력하지 않았다며... 필수 속성값을 입력하라는 오류를 경험해보신 적 있을 거예요. 특히 themeData와 같이 필수 속성값이 여러 개인 위젯을 사용할 때 많이 번거로웠습니다.
          // 이러한 불편은 copyWith() 함수를 사용하면 해결할 수 있습니다. 위젯의 기존 속성값은 그대로 사용하면서 변경하려는 속성값의 코드만 작성하면 되도록 도와주거든요.
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor
        ),
        title: 'Instagram clone',
        //flutterBuilder ->앨범에서 이미지 가져오. ㅂ배터리 표시, 파일 가져오, htto요청 일회성 응답에 사용.
        home: StreamBuilder( // 위치 업데이, 음악재생, 스톱위 일부데이터를 여러번 가져올때 사용.
          /**
           * 다음이 발생하면 이벤트가 시작됩니다.
              리스너가 등록된 직후입니다.
              사용자가 로그인한 경우.
              현재 사용자가 로그아웃된 경우.
              현재 사용자의 토큰에 변경 사항이 있는 경우
           */
          stream: FirebaseAuth.instance.idTokenChanges(), //authStateChange()
          builder: (context, snapshot) { //FirebaseAuth.instance.idTokenChanges() 데이터가 있으면  snapshot.data// snapshot은 data or error를 뱉음.
            if(snapshot.connectionState == ConnectionState.active) { //데이터가 들어오는중인지 checking
              print(snapshot.connectionState);
              print(snapshot.hasData);
              if (snapshot.hasData) { // 데이터가 있는지 -> login인지? -> user 환경에 맞는 화면을 그려줌.
                return const ResponsiveLyaout
                  (webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),);
              } else if (snapshot.hasError) { //에러인지
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) { /**아직 데이터가 안 들어왔고 들어오길 기다리는 중인지(loading)? active(들어오는중), none(하나도 안들어왔는지),done(전체다들어왔는지) http://www.incodom.kr/Flutter/FutureBuilder*/
              return const Center( //기다리는중이면 인디케이터 띄우고
                child: CircularProgressIndicator(
                color: primaryColor,
              ),);
            }
            return const LoginScreen(); //  idTokenChanges이 데이터가 들어오지 않거나 (snapshot)데이터가 없는경우 -> LoginPadge
          },
        )
      ),
    );
  }
}
