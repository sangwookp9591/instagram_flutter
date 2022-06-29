import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLyaout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLyaout(
      {
        Key? key,
        required this.webScreenLayout,
        required this.mobileScreenLayout
      }
      ) : super(key: key);

  @override
  State<ResponsiveLyaout> createState() => _ResponsiveLyaoutState();
}

class _ResponsiveLyaoutState extends State<ResponsiveLyaout> {
  /**웹 모바일 둘다 하기 위해*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  /**context.watch<T>()는 Provider.of<T>(context)와 동일하고, context.read<T>()는 Provider.of<T>(context, listen: false)와 동일하다. 그래서 둘 중 더 편한 쪽을 선택해서 사용하면 된다*/
  /***
   * Consumer는 위에서 말한 context.watch<T>(), context.read<T>()(혹은 Provider.of(context))를 사용할 수 없을 때 사용한다. 그렇다면 그런 경우는 언제일까? 바로 하나의 build 메소드에서 Provider를 생성도 하고 소비도 해야하는 상황이다. 이 때는 Consumer를 사용해야 Provider를 소비할 수 있다.
   * */
  addData() async {
    UserProvider _userProvider = Provider.of(context,listen: false); //함수를 가져올거야
    await _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    /**
     *  MediaQuery를 - 기기의 화면 크기알 수 있음
        하지만 기기의 전체 화면이 아니라 위젯의 크기를 알고싶다면 LayoutBuilder 사용
        물론 MediaQuery를 쓰고, 각 위젯의 height, width를 구해서 어찌저찌 구할 수는 있지만
        이 모든 것을 한방에 쉽게 해결하는 것이 LayoutBuilder.
     * */

    return LayoutBuilder(
        builder: (context, contraints){
          if(contraints.maxWidth > webScreenSize){
            //web screen
            return widget.webScreenLayout;
          }else{
            //mobile screen
            return widget.mobileScreenLayout;
          }

      },
    );
  }
}
