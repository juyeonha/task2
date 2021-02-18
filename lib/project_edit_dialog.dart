import 'dart:html';


import 'package:flutter/material.dart';
import 'package:task2/api.dart';
import 'package:task2/project_list_page.dart';
import 'package:task2/util.dart';


class ProjectEditDialog extends StatefulWidget {
  ProjectEditDialog ({this.edtiType, this.item });
  final String edtiType;
  final ProjectListItem item;
  @override
  _ProjectEditDialogState createState() => _ProjectEditDialogState();
}

class _ProjectEditDialogState extends State<ProjectEditDialog> with WidgetsBindingObserver {
  //위젯 레이어 바인딩에 등록하는 클래스용 인터페이스

  final TextEditingController _tecName = TextEditingController();
  final TextEditingController _tecMemo = TextEditingController();

  final FocusNode _focusName = FocusNode();
  final FocusNode _focusMemo = FocusNode();

  @override
  Future<bool> didPopRoute() {
    //시스템이 현재 경로를 표시하도록 앱에 지시 할 때 호출 합니다. ex)안드로이드 뒤로 가기 버튼 누를때 호출 참을 반환할때까지 옵저버는 등록 순서대로 알림을 받습니다.
    return Future.value(true); //ture를 반환하는 항목이 없으면 응용 프로그램이 종료됩니다.
  }

  void initState() {
    super.initState();
    //바인딩이라는 게 팝업 느낌...??????????????
    WidgetsBinding.instance.addObserver(
        this); //addObserver : 지정된 개체를 바인딩 관찰자로 등록 , 바인딩 관찰자는 이벤트가 있으면 알림을 받는다.
    WidgetsBinding.instance.addPostFrameCallback((
        _) { //addPostFrameCallback : 새프레임을 요청하지 않습니다.
      if (widget.edtiType == 'edit') {
        _tecName.text = widget.item.title;
        _tecMemo.text = widget.item.memo;
      }
    });
  }

  @override
  void dispose() {
    //state를 닫을 떄
    WidgetsBinding.instance.removeObserver(this); //주어진 관찰자를 등록해제 합니다.
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppbar(context), body: _buildBody(context)
    );
  }


  Widget _buildAppbar(BuildContext context) {
    //앱바 꾸미
    return AppBar(
      centerTitle: true,
      // 앱바 가운데 정렬
      elevation: 1,
      //그림자 거의 없음
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      //행간이 true고 null경우 자동완성 , 행간이 false고 null일 경우 공백
      leading: IconButton( //행간 닫기버튼
          icon: Icon(Icons.close, color: Colors.black),
          tooltip: '닫기!!!!!!!!!!!!!!!!!!!!',
          onPressed: () {
            Navigator.pop(context); //닫기를 눌렀을떄 context 가 무엇을 의미 하는??
          }
      ),
      title: Text(
          widget.edtiType == 'new' ? '새 프로젝트 생성' : '프로젝트 수정',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      actions: <Widget>[
      ],
    );
  }


  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView( //단일 위젯을 스크롤 할 수있는 상자입니다.
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('프로젝트 이름', style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
              SizedBox(height: 8),
              TextField(
                onSubmitted: (_) { //파라미터에 _ 그냥 써주신건가요??? 여러군데 있던데 의미없는건가요?
                },
                controller: _tecName,
                focusNode: _focusName,
                textInputAction: TextInputAction.next,
                maxLines: 12,
                scrollPadding: EdgeInsets.all(0),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: getColorFromHex('#e5e5e5')),
                  ),
                  hintText: "이름입력",
                  hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black),
                ),
              ),
              SizedBox(height: 8),
              Text('프로젝트 설명' , style:TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
              SizedBox(height: 8),
              TextField(
                onSubmitted: (_){
                },
                controller : _tecMemo,
                focusNode: _focusMemo,
                textInputAction: TextInputAction.next,
                maxLength: 100,
                scrollPadding: EdgeInsets.all(0),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: (){
                  if(widget.edtiType =='new'){
                    saveProject();
                  }else{
                    modifyProject();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: Text(widget.edtiType =='new'?'생성':'수정', style:TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                  decoration: BoxDecoration(
                    color: getColorFromHex('#37c3be'),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  void saveProject() {
    //필수값 확인
    if(_tecName.text.length < 2) {
      toast('이름을 확인해주세요.');
      _focusName.requestFocus();
      return;
    }

    //입력값에 무결성을 확인한다.
    String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/project';
    var header = {
      'Authorization': window.localStorage['token']
    };
    var body = {
      'title': _tecName.text,
      'memo': _tecMemo.text,
    };

    print(body.toString());

    Api().post(url, headers: header, body: body).then((response) {
      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 200) {
        //다이얼로그를 닫기 리플래시를 반환
        Navigator.pop(context, 'REFRESH'); // pop맨 위의  flutter인스턴스를 제거하여 이전 내용을 표시합니다.
      }
    });
  }

  void modifyProject() {
    //필수값 확인
    if(_tecName.text.length < 2) {
      toast('이름을 확인해주세요.');
      _focusName.requestFocus();
      return;
    }

    //입력값에 무결성을 확인한다.
    String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/project';
    var header = {
      'Authorization': window.localStorage['token']
    };
    var body = {
      'projectNo': widget.item.projectNo.toString(),
      'title': _tecName.text,
      'memo': _tecMemo.text,
    };

    print(body.toString());

    Api().put(url, headers: header, body: body).then((response) {
      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 200) {
        //다이얼로그를 닫기 리플래시를 반환
        Navigator.pop(context, 'REFRESH');
      }
    });
  }


}