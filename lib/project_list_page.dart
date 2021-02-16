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
          window.localStorage['isLogin']=='ture'?_buildLogout():_buildLogin(), //isLogin은 어디서 나온건가요?
          window.localStorage['isLogin']=='ture'?_buildBodyProjectList():_buildBodyEmpty(),
        //window.localStorage는 Documenat출처의 Stroage객체에 접근할 수 있습니다. 저장한 데이터는 브라우저 간 세션간에 공유됩니다.
          //@@
        ],
      ),
    );
  }

  Widget _buildLogin(){//Window.localStragep['isLogin']=='false' 여서 buildLogin()
    final TextEditingController _tecId =TextEditingController();
    final TextEditingController _tecPassword =TextEditingController();
    // TextEditingController() 아이디와 비밀번호를 받아오기 위한 컨트롤

    final FocusNode _idFcous =FocusNode();
    final FocusNode _passwordFocus =FocusNode();//@@ 이거는 물어보자

    return AutofillGroup( //AutofillGroup 잘모르겠다 @@
        child: Container(
          color: Colors.black12,
          padding: EdgeInsets.all(16),//모든 면에 16픽셀 여백
          child:Row(
            children:[
              SizedBox(
                width: 200,
                child: TextField(
                  onEditingComplete: (){
                    _idFcous.unfocus();
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                  focusNode: _idFcous,
                  textInputAction: TextInputAction.next,
                  scrollPadding: EdgeInsets.all(0),
                  controller: _tecId, //textfield의 컨트롤러로 지정해줍니다. 값을 가져올때는 _tecId.text
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  inputFormatters:[
                    FilteringTextInputFormatter.allow(RegExp("[a-z0-9]")), //로그인 형식 포맷 영어숫자만
                  ],
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),

                ),
              )
            ],
          )

        )
    );
  }






}

