import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/signup_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field.dart';
/**
 * SafeArea :
 * 요새 핸드폰마다 카메라, 버튼의 위치가 제각각이라 기종에 따라 내용이 가려지거나 사라지는 UI 가 있을 수 있습니다.
 * SafeArea의 위젯이 MediaQuery를 통해 앱의 실제 화면 크기를 계산하고 이를 영역으로 삼아 내용을 표시하기 때문에 잘리거나 가려지는 부분 없이 전부 나올수 있게 되는 것입니다.
 *
 * */
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState((){
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(email: _emailController.text, password: _passwordController.text);
    if (res == "success") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResponsiveLyaout(
              webScreenLayout: WebScreenLayout(), mobileScreenLayout: MobileScreenLayout(),
          ),
          ),
      );
      //
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const HomeScreen()));
    } else {
      //
      showSnackBar(res, context);
    }
    setState((){
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignupScreen(),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width/3)
              : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // svg image
                Flexible(child: Container(), flex: 2,),
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 64,),
                const SizedBox(height: 64,),
                TextFieldInput(
                    textEditingController: _emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress
                ),
                const SizedBox(height: 24,),
                // text field input for email
                TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                ),
                const SizedBox(height: 24,),
                InkWell(
                  onTap: loginUser,
                  child:Container(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        :const Text('login'),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: Colors.blue
                    ),
                ),
                ),
                const SizedBox(height: 12,),
                Flexible(
                  child: Container() ,
                  flex: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Don't have an account?"),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8
                      ),
                    ),
                    GestureDetector(
                      onTap: navigateToSignup,
                      child: Container(
                        child: const Text(
                            "Sign up.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                            )
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8
                        ),
                      ),
                    ),
                  ],
                )
                // text field input for password
                // button login
                // Transitiong to singing up
              ],
            ),
          )
      ),
    );
  }
}
