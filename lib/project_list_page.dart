import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task2/api.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:task2/util.dart';
import 'package:task2/project_edit_dialog.dart';

class ProjectListData{

  List<ProjectListItem> projectList = []; // projectList.add(new ProjectListItem.fromJson(i));

  ProjectListData({this.projectList}); //projectList == ProjectListData

  ProjectListData.fromJson(Map<String, dynamic> json){ //json['projectList] 사용하기 위해
    if(json['projectList']!=null){
      json['projectList'].forEach((v){ //projectList반복문
        print(v.toString());
        projectList.add(new ProjectListItem.fromJson(v)); //리스트에 더해준다.
      });

    }
  }

  Map<String, dynamic>toJson(){
    final Map<String,dynamic> data = new Map<String, dynamic>();

    if(this.projectList !=null){
      data['projectList'] =this.projectList.map((v) => v.toJson()).toList(); //Json형태로 변환, 보낼결과를 리스트로 변환
    }
    return data;

  }

}

class ProjectListItem{
  String projectType; //new
  int projectNo;
  String userId;
  String title;
  String memo= '';

  ProjectListItem({this.projectType, this.projectNo, this.userId, this.title, this.memo}); //constructor

  ProjectListItem.fromJson(Map<String, dynamic> json){ //json 데이터를 object로 변환
    projectType='';
    projectNo = json['projectNo'];
    userId = json['userId'];
    title = json['title'];
    memo = json['memo'];
    if(memo == null) // 한줄 밖에 없을떄는 중괄호 안씀
      memo ='';
  }


  Map<String,dynamic> toJson(){ //object 데이터를  json으로 변환
    final Map<String ,dynamic> data =new Map<String, dynamic>();
    data['projectNo'] =this.projectNo;
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
// createState()는 라이프사이클 주기에서 state오브젝트를 BuildContext와 연결
}

class _ProjectListPageState extends State<ProjectListPage> {
  bool loading = true;

  //실제적으로 실행되는 부분
  List<ProjectListItem> projectList = [];

  @override
  void initState() {
    super.initState();

    if (window.localStorage['isLogin'] == 'true') {
      loadProjectList();
    }


  }

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
    print('_buildBody');

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //column일 때 세로축을 기준으로 위쪽으로 정렬합니다.
        crossAxisAlignment: CrossAxisAlignment.start,
        //column일 때 세로축을 기준으로 왼쪽으로 정렬합니다.
        mainAxisSize: MainAxisSize.max,
        children: [
          window.localStorage['isLogin'] == 'true' ? _buildLogout() : _buildLogin(),
          //isLogin 세션간에 공유
          window.localStorage['isLogin'] == 'true' ? _buildBodyProjectList() : _buildBodyEmpty(),
          //window.localStorage는 Documenat출처의 Stroage객체에 접근할 수 있습니다.
        ],
      ),
    );
  }

  Widget _buildLogin() {
    //Window.localStragep['isLogin']=='false' 여서 buildLogin()
    final TextEditingController _tecId = TextEditingController();
    final TextEditingController _tecPassword = TextEditingController(); // TextEditingController() 아이디와 비밀번호를 받아오기 위한 컨트롤

    final FocusNode _idFocus = FocusNode();
    final FocusNode _passwordFocus = FocusNode();

    return AutofillGroup(
      //AutofillGroup : 이 메서드 안에 있는 입력필드가 자동채우기를 요청 플랫폼에서는 일반적으 '자동완성을 위해 저장하시겠습니까?'가 표시됨 사용자확인을 위한 프롬포트로 사용
      child: Container(
        color: Colors.black12, //로그인 바 색깔
        padding: EdgeInsets.all(16), //모든 면에 16픽셀 여백
        child: Row(
          children: [
            SizedBox( //로그인 박스 만들기
              width: 200, //박스크기 200 모든 기준 가로
              child: TextField( //박스안에 입력필드 만들기
                onEditingComplete: () {
                  // onEditingComplete 완료", "이동", "보내기"또는 "검색"과 같은 완료 동작을 누르면 사용자의 콘텐츠가 컨트롤러에 제출되고 포커스가 포기됩니다.
                  _idFocus.unfocus(); //포커스 해제
                  FocusScope.of(context)
                      .requestFocus(_passwordFocus); //비밀번호로 포커스 이동
                },
                focusNode: _idFocus,
                textInputAction: TextInputAction.next,
                //키보드의 엔터 위치에 해당하는 기능을 next로 변경
                scrollPadding: EdgeInsets.all(0),
                //스크롤바 없애기
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
                textAlign: TextAlign.start,
                decoration: InputDecoration( //입력필드 꾸미기 시작
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
            SizedBox( //비밀번호 사이즈박스
              width: 200,
              child: TextField(
                onEditingComplete: () { //앤터나 다음걸 실행했을경우
                  _passwordFocus.unfocus();
                  login(_tecId.text,
                      _tecPassword.text); //로그인 버튼으로 넘어간다. 로그인메서드로 넘어감!
                },
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.done,
                //키보드 엔터에 해당하는 액션을 완료로!
                controller: _tecPassword,
                //컨트롤러에서 비밀번호에 해당된다고 알려주
                autofocus: false,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration( //텍스트필드 꾸미기 시작!
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
            SizedBox(width: 16),
            SizedBox(
              // 로그인 버튼
              width: 100,
              child: InkWell(
                // Container와 같이 제스쳐기능을 제공하지 않는 위젯을 래핑하여 onTap 기능 제공
                onTap: () {
                  login(_tecId.text, _tecPassword.text); //로그인 메서드로 넘어감!
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 48,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Text('로그인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
              Container(), //Row , Column 또는 Flex 의 자식을 확장하여 자식 이 사용 가능한 공간을 채울 수 있도록 하는 위젯입니다 .
            ),
            SizedBox(
              width: 100,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/join'); //context에 대해서 조금은 이해가는 부분 : buildContext contextd인것  같다.
                },
                child: Container(
                  alignment: Alignment.center,
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
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Text(window.localStorage['username'] + '님 반갑습니다.'),
          Expanded(child: Container()),
          //Row , Column 또는 Flex 의 자식을 확장하여 자식 이 사용 가능한 공간을 채울 수 있도록 하 위젯입니다 .
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


  Widget _buildBodyEmpty() {
    // window.localStorage['isLogin'] == 'false' 빈페이지
    return Container(
      color: Colors.black12,
    );
  }

  Widget _buildBodyProjectList() {
    //로그인 성공시 리스트 카드 배열식으로 보여주기
    //SliverGridDelegateWithFixedCrossAxisCount를 사용하기 위해 설정값들
    var cellHeight = 200.0;
    var cellWidth = 200.0; //프로젝트 셀 너비
    var _aspectRatio = 1.0; //각 하위의 주축 범위에 대한 교차 축의 비율입니다.

    var _screenWidth = MediaQuery.of(context).size.width; //미디어쿼리를 사용한 넓이
    var _crossAxisCount = (_screenWidth / cellWidth).floor(); // 미디어쿼리 넓이/고정된 셀 넓  floor : 소수값이 존재할 때 소수값을 버리는 역활을 하는 함수 정수로 만들어줘야하기 때문

    return Expanded(
      child: GridView.builder( //스크롤 가능한 2D 위젯 배열입니다. 그리드의 주축 방향은 스크롤되는 방향입니다
        shrinkWrap: false,
        itemCount: projectList.length, //리스트 추가해줘야함
        gridDelegate: // 그리드의 타일 레이아웃을 계산
        SliverGridDelegateWithFixedCrossAxisCount( //맞춤 SliverGridDelegate 는 정렬되지 않거나 겹치는 배열을 포함하여 임의의 2D 자식 배열을 생성 할 수 있습니다.
            crossAxisCount: _crossAxisCount, childAspectRatio: _aspectRatio), //crossAxisCount 교차축의 자식 수 (정수)  , //childAspectRatio 하위의 주축 범위에 대한 교차 축의 비율 (double)
        itemBuilder: (context, index) {
          ProjectListItem item = projectList[index];


          return item.projectType == 'new' ? _buildNewProject(context) : _buildProjectCell(item);
        },
      ),
    );
  }


  Widget _buildNewProject(BuildContext context) {  //projectType == new 일경우
    var cellHeight =200.0;
    var cellWidth =200.0;

    return InkWell(
      onTap:(){
        _showEditDialog(context,'new',null);
      },
      child: Container(
        width: cellWidth,
        height: cellHeight,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.9), //이중불투명도 그림자 진하기 0 - 1.0사이의 값
              blurRadius: 4, //뒤에 블러처리
              offset: Offset(0,3) //뒤에 숫자를 크게 할수록 더 진하게 그림자 들어감
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('새프로젝트 생성', style:TextStyle(fontSize: 16,fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        )
      ),
    );
  }
  Widget _buildProjectCell(ProjectListItem item){ //projectType new가 아닐 경우 리스트에 보이는 셀
    var cellHeight =200.0;
    var cellWidth = 200.0;

    return InkWell(
      onTap: (){
        Navigator.pushNamed(context,'/work?projectNo='+item.projectNo.toString()); //이름을 통한 라우터간 이동
        /*
          onTap(){
            Navigator.push(context, MeterialPageRoute(builder:(context) => WorkPage()),);
                이 방식을 안쓰는 이유는 첫번째 라우터 버튼을 누를때 빌더를 통해 WorkPage가 생성되어 호출된다.만약 앱의 여러 부분에서
                위의 코드가 실행된다면 복수 메모리에 올라가게 되어 메모리낭비나 일관성이 꺠진다. 그래서 라우트 테이블에 라우트들을 경로형태의 이름으로 선언하고
                싱클톤 형태로 실행된다는 것으로 이해}
         */
      },
      child:Container(
        width: cellWidth,
        height: cellHeight,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:Colors.blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),
              blurRadius: 4,
              offset:Offset(0,3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children:[
                Flexible(child: Text(item.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
                //브라우저 창이 늘어나도 폰트사이즈 16로 주겠다.
                Visibility(
                  visible: window.localStorage['userId'] ==item.userId, //현재 userId의 값만 보여주겠다???
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: _projectPopup(item),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(height: 1,thickness: 1, color: Colors.white), //name과 memo를 구분해주는 선일까?
            SizedBox(height: 8),
            Text(item.memo , style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
            Expanded(child: Container()),
            Text(item.userId, style:TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
      )
    );
  }

  Widget _showEditDialog(BuildContext context,String editType,ProjectListItem item){
    showDialog(
      barrierDismissible: true,
      context: context, //context 허가증같은거
      builder: (BuildContext context){
        return WillPopScope(
          onWillPop: (){
            return Future.value(true);
          },
          child: ProjectEditDialog(
            edtiType :editType,
            item:item,
          ),
        );
      }
    ).then((val){
      if (val == 'REFRESH'){ //PorjectEditDialog 페이지에서 완성이되면 loadProejctList페이지를 다시 리로드 해주겠다.
        loadProjectList();
      }
    });

  }

  Future<void> login(String id, password) async {
    // login(_tecId.text, _tecPassword.text);
    String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/login';
    var body = {
      'userId': id,
      'password': password,
    };
    var res = await Api().post(url, body: body);
    var resJson = jsonDecode(res.body);
    if (res.statusCode == 200) {
      window.localStorage['token'] = resJson['token'];

      final String payload = resJson['token'].split('.')[1];
      window.localStorage['user'] = B64urlEncRfc7515.decodeUtf8(payload);
      var userJson = jsonDecode(window.localStorage['user']);
      window.localStorage['userId'] = userJson['userId'].toString();
      window.localStorage['username'] = userJson['username'].toString();
      window.localStorage['exp'] = userJson['exp'].toString();

      setState(() {
        window.localStorage['isLogin'] = 'true';
      });


      loadProjectList();

    } else {
      window.localStorage['token'] = null;
      window.localStorage['isLogin'] = 'false';
      toast(resJson['error']); //안드로이드 스튜디오에서 사용하는 토스트 메세지 빌드를 해줘야한다.
    }
  }

  Future<void> loadProjectList() async {
    // 값을 돌려주지 않습니다.  비동기
    String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/projectlist';

    var header = {'Authorization' : window.localStorage['token']};

    var res = await Api().get(url, headers: header);//api 메서드에서 인코딩(코드로 변환된값)을 해서 줍니다.res 에는 받아온 값이 들어있다.


    var data = ProjectListData.fromJson(jsonDecode(res.body)); //jsonDecode()기능을 이용해 JSON데이타구조를  map<String ,dynamic> 데이타 타입으로 변경
      //ProjectListData로 타고 들어가보면 projectListData가 projectList인것을 알 수있습니다.
    projectList.clear();
    projectList.add(ProjectListItem(projectType: 'new'));
    projectList.addAll(data.projectList);

    for(ProjectListItem item in data.projectList){ //projectList에 들어있는 값들을 ProjectListItme 변수에 맡게 할당
      print(item.toJson().toString()); //{projectNo: 137, userId: gaebal, title: 한글 프로젝트, memo: 잘 생성되었나요?}

    }

    setState(() { });
 }

  void editProject(){}

  Future<void> deleteProject(ProjectListItem item) async {
    String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/project';
    url = url + '?projectNo=' + item.projectNo.toString();
    var header = {
      'Authorization': window.localStorage['token']
    };

    var res = await Api().delete(url, headers: header);
    if (res.statusCode == 200) {
      loadProjectList();
    }

    setState(() {

    });
  }

  Widget _projectPopup(ProjectListItem item) =>
      PopupMenuButton<int>(
        icon: Icon(Icons.more_vert, size: 18, color: Colors.white),
        onSelected: (value) async {
          if (value == 1) {
            //수정하기 화면으로 이동
            _showEditDialog(context, 'edit', item);
          } else if (value == 2) {
            //정말로 삭제할것인가?
            showDialog<void>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(item.title + ' 삭제'),
                  content: Text('정말로 삭제하시겠습니까?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('취소'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('삭제하기' , style: TextStyle(color: Colors.black)),
                      onPressed: () {
                        deleteProject(item).then((value) {
                          loadProjectList().then((value) {
                            Navigator.pop(context);
                          });
                        });
                      },
                    )
                  ],
                );
              },
            );
          }
        },
        itemBuilder: (context) =>
        [
          PopupMenuItem(
            value: 1,
            child: Text("수정하기", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)),
          ),
          PopupMenuItem(
            value: 2,
            child: Text("삭제하기", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)),
          ),
        ],
      );
}





