import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task2/api.dart';
import 'package:task2/util.dart';

//
class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {

  final TextEditingController _tecName = TextEditingController();
  final TextEditingController _tecId = TextEditingController();
  final TextEditingController _tecPassword1 = TextEditingController();
  final TextEditingController _tecPassword2 = TextEditingController();
  final TextEditingController _tecEmail = TextEditingController();
  final TextEditingController _tecJobTitle = TextEditingController();
  final TextEditingController _tecDepartment = TextEditingController();


  final FocusNode _focusName = FocusNode();
  final FocusNode _focusId = FocusNode();
  final FocusNode _focusPassword1 = FocusNode();
  final FocusNode _focusPassword2 = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusJobTitle = FocusNode();
  final FocusNode _focusDepartment = FocusNode();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }


  Widget _buildAppbar() {
    return AppBar(
      centerTitle: true,
      title: Text('회원가'),
    );
  }

  Widget _buildBody() {
    //SingleChildScrollView 스크롤이 필요한 차일드를 가지는 컬럼 등의 요소를 감싸는데/
    //컬럼은 기본적으로 무제한 세로 사이즈를 가지므로
    //컬럼의 높이를 컨테이너 또는 익스펜디드 위젯으로 정해준 후
    //singlichildscrollview로 감싸야함
    //높이를 정해주는 역할을 하는 컨테이너 또는 익스펜디드 위젯을 감싸면 안되고
    //높이를 정해주는 위젯이 아니라면
    // 컨테이너라도 높이를 정하는 설정이 없다면
    //싱글차이드스크롤뷰 위젯과 컬럼 위젯 사이에 올수 있음
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이름', style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
            SizedBox(height: 8),
            TextField(
              onSubmitted: (_) {
                _focusId.requestFocus();
              },
              controller: _tecName,
              focusNode: _focusName,
              textInputAction: TextInputAction.next,
              maxLength: 12,
              scrollPadding: EdgeInsets.all(0),
              style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: getColorFromHex('#e5e5e5')),
                  ),
                  hintText: '실명 입력',
                  hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black12)
              ),
            ),
            SizedBox(height: 8),
            Text('아이디', style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
            SizedBox(height: 8),
            TextField(
              onSubmitted: (_) {
                _focusId.requestFocus();
              },
              controller: _tecId,
              focusNode: _focusId,
              autofillHints: [AutofillHints.newUsername],
              textInputAction: TextInputAction.next,
              maxLength: 12,
              scrollPadding: EdgeInsets.all(0),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-z]")),
              ],
              style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: getColorFromHex('#e5e5e5')),
                ),
                hintText: '아이디 입력',
                hintStyle: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w500, color: Colors.black12),
              ),
            ),
            SizedBox(height: 8),
            Text('비밀번호' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
            SizedBox(height: 8),
            TextField(
              onSubmitted: (_){
                _focusPassword1.requestFocus();
              },
              controller: _tecPassword1,
              focusNode: _focusPassword1,
              autofillHints: [AutofillHints.newPassword],//autofill 자동채움
              textInputAction: TextInputAction.next,
              maxLength: 12,
              scrollPadding:EdgeInsets.all(0),
              keyboardType: TextInputType.visiblePassword, //비밀번호 타입
              obscureText: true,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color:getColorFromHex('#e5e5e5')),
                ),
                hintText: '비밀번호 입력',
                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black12),
              ),
            ),
            SizedBox(height: 8),
            Text('비밀번호' , style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
            SizedBox(height: 8),
            TextField(
              onSubmitted: (_){
                _focusPassword2.requestFocus();
              },
              controller: _tecPassword2,
              focusNode: _focusPassword2,
              textInputAction: TextInputAction.next,
              maxLength: 12,
              scrollPadding:EdgeInsets.all(0),
              keyboardType: TextInputType.visiblePassword, //비밀번호 타
              obscureText: true,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color:getColorFromHex('#e5e5e5')),
                ),
                hintText: '비밀번호 입력',
                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black12),
              ),
            ),
            SizedBox(height: 8),
            Text('이메일',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black)),
            SizedBox(height: 8),
            TextField(
              onSubmitted: (_){
                _focusDepartment.requestFocus();
              },
              controller: _tecEmail,
              focusNode: _focusEmail,
              textInputAction: TextInputAction.next,
              maxLength: 64,
              scrollPadding: EdgeInsets.all(0),
              keyboardType: TextInputType.emailAddress, //이메일 타입
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8), //텍스트필드 안에 글자 여백
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.green), //??????\
                ),
                hintText: '이메일 입력',
                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black12),
              ),
            ),
            SizedBox(height: 8),
            Text('부서',style:TextStyle(fontSize: 16, fontWeight:FontWeight.w500, color: Colors.black)),
            SizedBox(height: 8),
            TextField(
              onSubmitted: (_){
                _focusDepartment.requestFocus();
              },
              controller: _tecDepartment,
              focusNode: _focusDepartment,
              textInputAction: TextInputAction.next,
              maxLength: 12,
              scrollPadding: EdgeInsets.all(0),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: getColorFromHex('#e5e5e5')),
                  ),
                  hintText: '부서입력',
                  hintStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500, color: Colors.black12),
                ),
            ),
            SizedBox(height: 8),
            Text('직함',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500, color: Colors.black)),
            SizedBox(height: 8),
            TextField(
              controller: _tecJobTitle,
              focusNode: _focusJobTitle,
              textInputAction: TextInputAction.done,
              maxLength: 12,
              scrollPadding: EdgeInsets.all(0),
              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: getColorFromHex('#e5e5e5')),
                ),
                hintText: '직함입력',
                hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black12),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap:(){
                join();
              },
              child: Container(
                alignment: Alignment.center,
                height: 48,
                width: MediaQuery.of(context).size.width, //화면의 값을 구해주는 미디어쿼
                child: Text('회원가입',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                decoration: BoxDecoration(
                  color: getColorFromHex('#37c3be'),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



void join() {
  if (_tecName.text.length < 2) {
    toast('이름을 확인해 주세요.');
    _focusName.requestFocus();
    return;
  }
  if (_tecId.text.length < 4) {
    toast('아이디를 확인해 주세요.(4자이상)');
    _focusId.requestFocus();
    return;
  }
  if (_tecPassword1.text.length < 4) {
    toast('비밀번호를 확인해주세요.(4자이상)');
    _focusPassword1.requestFocus();
    return;
  }
  if (_tecPassword2.text != _tecPassword1.text) {
    toast('확인 비밀번호가 틀립니다.');
    return;
  }

  String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/join';
  var body = {
    'username': _tecName.text,
    'userId': _tecId.text,
    'password': _tecPassword1.text,
    'email': _tecEmail.text,
    'department': _tecDepartment.text,
    'jobtitle': _tecJobTitle.text,
  };
  print(body.toString());


  Api().post(url, body: body).then((response) {
    print(response.body);
    if (response.statusCode == 200) {
      //성공이면 받아온 아이디와 비밀번호를 넣어준다.
      var body = {
        'useId': _tecId.text,
        'password': _tecPassword1.text,
      };
      Api().post(url, body: body).then((resLogin) {
        //받아온 아이디와 비밀번호를 로그인으로 보내준다.???
        if (resLogin.statusCode == 200) { //200 성공
          Navigator.pop(context); //pop 끄다
        } else {
          Navigator.pop(context);
        }
      });
    } else{
      toast('회원가입에 실패했습니다.');
    }
  });
  }
}
