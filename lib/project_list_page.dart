import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task2/api.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';


// class ProjectListData { //여긴ㄴ 아
//   List<ProjectListItem> projectList;
//
//   ProjectListData({this.projectList});
//
//   ProjectListData.fromJson(Map<String, dynamic> json) {
//     if (json['projectList'] != null) {
//       projectList = new List<ProjectListItem>();
//       json['projectList'].forEach((v) {
//         projectList.add(new ProjectListItem.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.projectList != null) {
//       data['projectList'] = this.projectList.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }


class ProjectListItem{ //여기까지는 이
  String ProjectType;
  int projectNo;
  String userId;
  String title;
  String memo;

  ProjectListItem(this.ProjectType, this.projectNo, this.userId, this.title, this.memo);

  ProjectListItem.fromJson(Map<String, dynamic> json){ //json 데이터를 object로 변환
    ProjectType='';
    projectNo = json['projectNo'];
    userId = json['useId'];
    title = json['title'];
    memo = json['memo'];
    if(memo == null) //if 문 이렇게 쓴느구나...신
      memo ='';
  }

  Map<String,dynamic> toJson(){
    final Map<String ,dynamic> data =new Map<String, dynamic>();
    data['proejctNo'] =this.projectNo;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['memo'] = this.memo;
    return data;
  }
}



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

  Widget _buildAppbar() {
    return AppBar(centerTitle: true, title: Text('Hero Task') // @@
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //column일 때 세로축을 기준으로 위쪽으로 정렬합니다.
        crossAxisAlignment: CrossAxisAlignment.start,
        //column일 때 세로축을 기준으로 왼쪽으로 정렬합니다.
        mainAxisSize: MainAxisSize.max,
        children: [
          window.localStorage['isLogin'] == 'ture' ? _buildLogout() : _buildLogin(),
          //isLogin 세션간에 공유
          window.localStorage['isLogin'] == 'ture' ? _buildBodyProjectList() : _buildBodyEmpty(),
          //window.localStorage는 Documenat출처의 Stroage객체에 접근할 수 있습니다. 저장한 데이터는 브라우저 간 세션간에 공유됩니다. 최신기술 캐시는 옛날기술
          //@@
        ],
      ),
    );
  }

  Widget _buildLogin() {
    //Window.localStragep['isLogin']=='false' 여서 buildLogin()
    final TextEditingController _tecId = TextEditingController();
    final TextEditingController _tecPassword =
    TextEditingController(); // TextEditingController() 아이디와 비밀번호를 받아오기 위한 컨트롤

    final FocusNode _idFcous = FocusNode();
    final FocusNode _passwordFocus = FocusNode();

    return AutofillGroup(
      //AutofillGroup : 이 메서드 안에 있는 입력필드가 자동채우기를 요청 플랫폼에서는 일반저5ㄱ으로 '자동완성을 위해 저장하시겠습니까?'가 표시됨 사용자확인을 위한 프롬포트
      child: Container(
        color: Colors.black12, //로그인 바 색깔
        padding: EdgeInsets.all(16), //모든 면에 16픽셀 여백
        child: Row(
          //가로로,여기를  Column으로 하면 세로로된다.
          children: [
            SizedBox(
              //로그인 박스 만들기
              width: 200, //박스크기 200 모든 기준 가로
              child: TextField(
                //박스안에 입력필드 만들기
                onEditingComplete: () {
                  // onEditingComplete 완료", "이동", "보내기"또는 "검색"과 같은 완료 동작을 누르면 사용자의 콘텐츠가 컨트롤러에 제출되고 포커스가 포기됩니다.
                  _idFcous.unfocus(); //포커스 해제
                  FocusScope.of(context)
                      .requestFocus(_passwordFocus); //비밀번호로 포커스 이동
                },
                focusNode: _idFcous,
                textInputAction: TextInputAction.next,
                //키보드의 엔터 위치에 해당하는 기능을 next로 변경
                scrollPadding: EdgeInsets.all(0),
                //스크롤바 없애
                controller: _tecId,
                //textfield의 컨트롤러로 지정해줍니다. 값을 가져올때는 _tecId.text
                autofocus: true,
                //첫페이지 들어가 있을떄 포커스
                keyboardType: TextInputType.number,
                //숫자만을 입력
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-z0-9]")),
                  //로그인 형식 포맷 영어숫자만
                ],
                textAlignVertical: TextAlignVertical.center,
                //어디에 적용됐는지 더 찾아보기
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  //입력필드 꾸미기 시작
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5), //테두리 둥굴게
                    borderSide: BorderSide(color: Colors.red), //
                  ),
                  hintText: '아이디를 입력해주세요',
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: 8), //띄어쓰기 deco 설정해주지 않으면 여백처럼 보인다.
            SizedBox(
              //비밀번호 사이즈박스
              width: 200,
              child: TextField(
                onEditingComplete: () {
                  //앤터나 다음걸 실행했을경우
                  _passwordFocus.unfocus();
                  login(_tecId.text, _tecPassword.text); //로그인 버튼으로 넘어간다. 로그인메서드로 넘어감!
                },
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                //키보드 엔터에 해당하는 액션을 완료로!
                controller: _tecPassword,
                //컨트롤러에서 비밀번호에 해당된다고 알려주
                autofocus: false,
                //위에는 ture로 달았는데 꼭 달아야 하나요? 방지용인가요?
                textAlignVertical: TextAlignVertical.center,
                //@@ 주석 달아보면서 보자
                decoration: InputDecoration(
                  //텍스트필드 꾸미기 시작!
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  hintText: '비밀번호입력',
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: 16), //띄어쓰기 deco 설정해주지 않으면 여백처럼 보인다.
            SizedBox(
              // 로그인 버튼
              width: 100,
              child: InkWell(
                // Container와 같이 제스쳐기능을 제공하지 않는 위젯을 래핑하여 onTap 기능 제공
                onTap: () {
                  //기능을 위에쓰고 꾸미는건 밑에 쓰나요? 이게 룰인가요?
                  login(_tecId.text, _tecPassword.text); //로그인 메서드로 넘어감!
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 48,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  //화면 크기를 얻기 위해 MediaQuery라는 클래스를 이용한다.화면 크기만 얻은건가요? 쓰는 방법 더찾아보기
                  child: Text('로그인',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
              Container(), //Row , Column 또는 Flex 의 자식을 확장하여 자식 이 사용 가능한 공간을 채울 수 있도록 하는 위젯입니다 .라고는 하는데 맨 끝에 위치하게 하는건가요?
            ),
            SizedBox(
              width: 100,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context,
                      '/join'); //context에 대해서 조금은 이해가는 부분 : buildContext contextd인것  같다.
                },
                child: Container(
                  alignment: Alignment.center,
                  //회원가입 창 가운데? 무엇을?
                  height: 48,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Text('회원가입',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5), //모서리 깍기
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogout() {
    //로그인아웃이라고 되어있지만 로그인이 된 상태를 말한다.
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Text(window.localStorage['username'] + '님 반갑습니다.'),
          Expanded(child: Container()),
          //Row , Column 또는 Flex 의 자식을 확장하여 자식 이 사용 가능한 공간을 채울 수 있도록 하는 위젯입니다 .
          SizedBox(
            width: 100, //컨테이너 사이즈
            child: InkWell(
              onTap: () {
                //사이즈박스 누를경우 액션
                setState(() {
                  window.localStorage['isLogin'] = 'false';
                  window.localStorage['token'] = null;
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: 48,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                //창의 비율에 맞춰주세요 ~
                child: Text('로그아웃',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBodyEmpty() { // window.localStorage['isLogin'] == 'false' 빈페이지
    return Container(
      color: Colors.black12,  // @@
    );
  }

  Widget _buildBodyProjectList() { //로그인 성공시 리스트 카드 배열식으로 보여주기
    //SliverGridDelegateWithFixedCrossAxisCount를 사용하기 위해 설정값들
    var cellHeight =200.0;
    var cellWidth =200.0;//프로젝트 셀 너비
    var _aspectRatio =1.0;//각 하위의 주축 범위에 대한 교차 축의 비율입니다.

    var _screenWidth= MediaQuery.of(context).size.width;//미디어쿼리를 사용한 넓이
    var _crossAxisCount =(_screenWidth /cellWidth).floor();// 미디어쿼리 넓이/고정된 셀 넓  floor : 소수값이 존재할 때 소수값을 버리는 역활을 하는 함수 정수로 만들어줘야하기 때문

    return Expanded(
      child: GridView.builder(//스크롤 가능한 2D 위젯 배열입니다. 그리드의 주축 방향은 스크롤되는 방향입니다
        shrinkWrap: false,
        itemCount: projectList.lenth, //리스트 추가해줘야함
        gridDelegate: // 그리드의 타일 레이아웃을 계산
        SliverGridDelegateWithFixedCrossAxisCount( //맞춤 SliverGridDelegate 는 정렬되지 않거나 겹치는 배열을 포함하여 임의의 2D 자식 배열을 생성 할 수 있습니다.
          crossAxisCount: _crossAxisCount, childAspectRatio: _aspectRatio//crossAxisCount 교차축의 자식 수 (정수)  , //childAspectRatio 하위의 주축 범위에 대한 교차 축의 비율 (double)
        ),
          itemBuilder: (context, index){
          ProjectListItem item = projectList[index]; //리스트 ... 어렵다 어떻게 가져오는지 모르겠지만 우선 진행 닭이먼저냐 알이먼저냐 고민하고있음
          return itme.projectType =='new'? _buildNewProject(context) : _buildProjectCell(item);
          },
      ),
    );
  }
}




  Future<void> login(String id, password) async { // login(_tecId.text, _tecPassword.text);
    String url ='https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/login';
    var body ={
      'userId': id;
      'password':password;
    };
    var res = await Api().post(url,body:body); //post 형식으로 보내겠다. res에 리턴값 들어오게된다.
    var resJosn =jsonDecode(res.body); //리턴값을 디코딩 해준다. 내가 생각하는 디코딩 보여드리기
    if(res.statusCode == 200){
      window.localStorage['token'] =resJosn['token'];
      final String payload = resJosn['token'].split('.')[1];
      //페이로드는 전송의 근본적인 목적이 되는 데이터의 일부분으로 그 데이터와 함께 전송되는 헤더와 메타데이터와 같은 데이터는 제외한다.
      window.localStorage['User'] =B64urlEncRfc7515.decodeUtf8(payload); //jaguar_jwt(JSON 웹 토큰 (JWT)을 생성하고 처리하는 데 사용) 패키지 Base64url 인코딩
      var userJson =jsonDecode(window.localStorage['user']); //user 에는  userId, username ,exp를 가지고 있다.
      window.localStorage['userId'] = userJson['userId'].toString();
      window.localStorage['username'] = userJson['username'].toString();
      window.localStorage['exp'] =userJson['exp'].toString();


      setState(() { //상태 변
      window.localStorage['isLogin'] = 'true';
      });


      //여기서 부터 물어볼려고 안침 복사 한것들 다시지우고 치겠습니다.
    loadProjectList(); // 리스트 로드 해주는 메서드

    } else {
    window.localStorage['token'] = null;
    window.localStorage['isLogin'] = 'false';
    // toast(resJson['error']); //여기는 혼자 공부를 더 해보겠습니다.
    }

    }

  Future<void> loadProjectList() async { // 값을 돌려주지 않습니다.  비동식
    String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/projectlist';
    var header = {
      'Authorization': window.localStorage['token']
    };
    var res = await Api().get(url, headers: header); // 리스트 가져오기
}


  }




