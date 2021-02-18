import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



Color getColorFromHex(String hexColor){
  hexColor =hexColor.toUpperCase().replaceAll('#', ''); //헥스 컬러 ex)#37c3be

  if(hexColor.length ==6){ //#을 떼고 6자리
    hexColor ='FF' +hexColor;
  }

  return Color(int.parse(hexColor,radix: 16));

  //parse메서드는 문자열을 입력인자로 받아 문자열을 정수로 변환하여 반환합니다.
  //문자열 =>정수 int.parse('42') , 16진 문자열=> 정수 int.parse('FF',radix:16); //255 ,입력문자열이 유효하지 않는 정수는  FomatException


}

void toast(String msg){
  int sec =msg.length ~/15; // ~/ ??????
  if(sec<2)
    sec=2;
  Fluttertoast.showToast(msg: msg,
  gravity: ToastGravity.TOP, //메세지 위
  timeInSecForIosWeb: sec,
  backgroundColor: getColorFromHex('#37C3BE'),
  textColor: Colors.white,
    fontSize: 18.0
  );
}



