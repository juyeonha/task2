

import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task2/api.dart';
import 'package:task2/util.dart';
import 'package:task2/work_page.dart';

class AddCardDialog extends StatefulWidget {
  AddCardDialog({this.projectNo, this.workList});
  final int projectNo;
  final List<WorkListItem> workList;


  @override
  _AddCardDialogState createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog>  with WidgetsBindingObserver {
  String currentWorkNo;


  final TextEditingController _content =TextEditingController();
  final TextEditingController _workNo =TextEditingController();


  final FocusNode _focusContent =FocusNode();


  @override
  void initState() {
    super.initState();
    currentWorkNo = widget.workList[0].workNo.toString();
  }


  @override
  Future<bool> didPopRoute() {
    return Future.value(true);
  }

  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //   });
  // }

  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }
  //


  @override
  Widget build(BuildContext context) {
    //widget.item.projectNo
    //widget.item.projectNo


    return Scaffold(
      appBar: _buildAppbar(),
      body:_buildBody(),
    );
  }



Widget _buildAppbar() {
    return AppBar(
      centerTitle: true,
      title: Text('일정 추가하기'),
    );
}

Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text('진행 목록 선택하세요',style:TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: getColorFromHex('#344058'))),
            Container(
              padding: EdgeInsets.all(8),
              child: DropdownButton(
                value: currentWorkNo,
                items: widget.workList.map((item) {
                  print(item.toJson().toString());
                  return DropdownMenuItem(child: Text(item.workTitle),value: item.workNo.toString());
                }).toList(),
                // items: [
                //   //workNo 151
                //   DropdownMenuItem(child: Text("First Item"),value: 1,),
                //   DropdownMenuItem(child: Text("second Item"),value: 2,),
                //   DropdownMenuItem(child: Text("third Item"),value: 3,),
                // ],
                onChanged: (value){
                  setState(() {
                    currentWorkNo = value;
                  });
                },
              ),

            ),

            //셀렉트 박스 만들기 workTitle for문 돌려서 목록 띄우기


            Text('내용',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: getColorFromHex('#344058'))),
            SizedBox(height: 8),
            TextField(onSubmitted: (_){
              _focusContent.requestFocus();
            },
            controller: _content,
              focusNode: _focusContent,
              textInputAction: TextInputAction.next,
              maxLength: 10,
              scrollPadding: EdgeInsets.all(0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: getColorFromHex('E5E5E5')),
                ),
                hintText: '내용 입력',
                hintStyle:  TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: getColorFromHex('A1A7B1'))
              ),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                  saveProject();
              },
              child: Container(
                alignment: Alignment.center,
                height: 48,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Text('일정 추가하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color:Colors.white)),
                decoration: BoxDecoration(
                  color: getColorFromHex('37C3BE'),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              ),
          ],
        ),
      ),
    );
}
  void saveProject(){
    if(_content.text.length<2){
      toast('내용을 입력해주세요');
      _focusContent.requestFocus();
      return;
    }

    String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/card';
    var header ={
      'Authorization': window.localStorage['token']
    };

    var body={
      'projectNo': widget.projectNo.toString(),
      'content': _content.text,
      'workNo': '111',
    };

    print(body.toString());

    Api().post(url, headers: header, body:body).then((response){
      print(response.statusCode);
      print(response.body);
      if(response.statusCode==200){
       Navigator.pop(context,'REFRESH'); //중복이 생김
       // setState(() {
       //   Navigator.pushNamed(context,'/work?projectNo='+item.projectNo.toString());
       //
       // });
      }

    });
  }

}
