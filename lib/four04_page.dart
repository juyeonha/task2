import 'package:flutter/material.dart';

class Four04Page extends StatelessWidget {
  final String message; //final  한번 설정한 값을 변경할 수 없게 한다.
  Four04Page(this.message);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar:AppBar(title: Text('Page Not Found')),
    body: Center(child: Text(message)),
  );
}


/* 원래 형식은 이거 참고자료로 놔둡니다.
Widget build(BuildContext context) {
  return Scaffold( //
    appBar: _buildAppbar(),
    body: _buildBody(),
  );
}*/
