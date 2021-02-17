import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ProjectListPage extends StatefulWidget {
  @override
  _ProjectListPageState createState() => _ProjectListPageState();
  // _변수명은 private 와 같은 의미
  // createState()는 라이프사이클 주기에서 state오브젝트를 BuildContext와 연결 (두루뭉실하게 안다 더 공부하.)
}

class _ProjectListPageState extends State<ProjectListPage> {
  //실제적으로 실행되는 부분

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppbar(){
    return AppBar(
      centerTitle: true,
      title: Text('Hero Task') // @@
    );
  }

  Widget _buildBody(){
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start , //column일 때 세로축을 기준으로 위쪽으로 정렬합니다.
        crossAxisAlignment: CrossAxisAlignment.start ,//column일 때 세로축을 기준으로 왼쪽으로 정렬합니다.
        mainAxisSize: MainAxisSize.max,
        children: [
         //  window.localStorage['isLogin']=='ture'?_buildLogout():_buildLogin(), //isLogin 세션간에 공유
           //window.localStorage['isLogin']=='ture'?_buildBodyProjectList():_buildBodyEmpty(),
        //window.localStorage는 Documenat출처의 Stroage객체에 접근할 수 있습니다. 저장한 데이터는 브라우저 간 세션간에 공유됩니다. 최신기술 캐시는 옛날기
          //@@
        ],
      ),
    );
  }

  Widget _buildLogin(){   //Window.localStragep['isLogin']=='false' 여서 buildLogin()
    final TextEditingController _tecId =TextEditingController();
    final TextEditingController _tecPassword =TextEditingController(); // TextEditingController() 아이디와 비밀번호를 받아오기 위한 컨트롤

    final FocusNode _idFcous =FocusNode();
    final FocusNode _passwordFocus =FocusNode();

    return AutofillGroup( //AutofillGroup : 이 메서드 안에 있는 입력필드가 자동채우기를 요청 플랫폼에서는 일반저5ㄱ으로 '자동완성을 위해 저장하시겠습니까?'가 표시됨 사용자확인을 위한 프롬포트
        child: Container(
          color: Colors.black12, //로그인 바 색깔
          padding: EdgeInsets.all(16),//모든 면에 16픽셀 여백
          child:Row( //가로로,여기를  Column으로 하면 세로로된다.
            children:[
              SizedBox( //로그인 박스 만들기
                width: 200,//박스크기 200 모든 기준 가로
                child: TextField( //박스안에 입력필드 만들기
                  onEditingComplete: (){ // onEditingComplete 완료", "이동", "보내기"또는 "검색"과 같은 완료 동작을 누르면 사용자의 콘텐츠가 컨트롤러에 제출되고 포커스가 포기됩니다.
                    _idFcous.unfocus(); //포커스 해제
                    FocusScope.of(context).requestFocus(_passwordFocus);//비밀번호로 포커스 이동
                  },
                  focusNode: _idFcous,
                  textInputAction: TextInputAction.next,//키보드의 엔터 위치에 해당하는 기능을 next로 변경
                  scrollPadding: EdgeInsets.all(0),//스크롤바 없애
                  controller: _tecId, //textfield의 컨트롤러로 지정해줍니다. 값을 가져올때는 _tecId.text
                  autofocus: true, //첫페이지 들어가 있을떄 포커스
                  keyboardType: TextInputType.number, //숫자만을 입력
                  inputFormatters:[
                    FilteringTextInputFormatter.allow(RegExp("[a-z0-9]")), //로그인 형식 포맷 영어숫자만
                  ],
                  textAlignVertical: TextAlignVertical.center,//어디에 적용됐는지 더 찾아보기
                  textAlign: TextAlign.start,
                  decoration: InputDecoration( //입력필드 꾸미기 시작
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5), //테두리 둥굴게
                      borderSide: BorderSide(color: Colors.red), //
                     ),
                    hintText: '아이디를 입력해주세요',
                    hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width: 8), //띄어쓰기 deco 설정해주지 않으면 여백처럼 보인다.
              SizedBox( //비밀번호 사이즈박스
                width:200,
                child:TextField(
                  onEditingComplete: (){ //앤터나 다음걸 실행했을경우
                    _passwordFocus.unfocus();
                    login(_tecId.text,_tecPassword.text); //로그인 버튼으로 넘어간다. 로그인메서드로 넘어감!
                  },
                  focusNode: _passwordFocus,
                  textInputAction: TextInputAction.done, //키보드 엔터에 해당하는 액션을 완료로!
                  controller: _tecPassword, //컨트롤러에서 비밀번호에 해당된다고 알려주
                  autofocus: false, //위에는 ture로 달았는데 꼭 달아야 하나요? 방지용인가요?
                  textAlignVertical: TextAlignVertical.center, //@@ 주석 달아보면서 보자
                  decoration: InputDecoration( //텍스트필드 꾸미기 시작!
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    hintText: '비밀번호입력',
                    hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width:16), //띄어쓰기 deco 설정해주지 않으면 여백처럼 보인다.
              SizedBox(// 로그인 버튼
                width:100,
                child:InkWell( // Container와 같이 제스쳐기능을 제공하지 않는 위젯을 래핑하여 onTap 기능 제공
                  onTap: (){ //기능을 위에쓰고 꾸미는건 밑에 쓰나요? 이게 룰인가요?
                    login(_tecId.text,_tecPassword.text); //로그인 메서드로 넘어감!
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 48,
                    width: MediaQuery.of(context).size.width, //화면 크기를 얻기 위해 MediaQuery라는 클래스를 이용한다.화면 크기만 얻은건가요? 쓰는 방법 더찾아보기
                    child: Text('로그인',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }





  Future<void> login(String id, password) async { //아이디, 패스워드 어디서 받아왔어?
    // String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/login';
    // var body = {
    //   'userId': id,
    //   'password': password,
    // };
    // var res = await Api().post(url, body: body);
    // var resJson = jsonDecode(res.body);
    // if(res.statusCode == 200) {
    //   window.localStorage['token'] = resJson['token'];
    //
    //   final String payload = resJson['token'].split('.')[1];
    //   window.localStorage['user'] = B64urlEncRfc7515.decodeUtf8(payload);
    //   var userJson = jsonDecode(window.localStorage['user']);
    //   window.localStorage['userId'] = userJson['userId'].toString();
    //   window.localStorage['username'] = userJson['username'].toString();
    //   window.localStorage['exp'] = userJson['exp'].toString();
    //
    //   setState(() {
    //     window.localStorage['isLogin'] = 'true';
    //   });
    //
    //   loadProjectList();
    //
    // } else {
    //   window.localStorage['token'] = null;
    //   window.localStorage['isLogin'] = 'false';
    //   toast(resJson['error']);
    // }
  }



}

