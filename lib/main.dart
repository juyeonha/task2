import 'package:flutter/material.dart';
//플루터는 widge으로 앱의 화면을 구성한다.

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{ //StatelessWidget 변경되지 않는 , 위젯 하위클래스들 : Icon,IconButton,Text
  @override //tatelessWidget을 상속하는 Widget은 , "Widget build(BuildContext context)" 를 오버라이딩 해야한다.
  Widget build(BuildCOntext context){ //각각의 위젯마다 고유의 BuildContext 가 존재
    return MaterialApp( //MaterialApp은 Theme(테마)와 Route(이동)을 담당
      //Text 위젯 , Dropdown 버튼  위젯 , AppBar 위젯 , Scaffold 위젯 , ListView 위젯 , StatelessWidget , StatefulWidget , IconButton 위젯 , TextField 위젯 , Padding 위젯 , ThemeData 위젯
    title:'WinWin Kanban', //appbar 에 보여지는 타이
      theme: ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0), //앱바 컬러색깔
      ),
     // home: ProjectListPage(),
      onGenerateRoute: onGenerateRoute,
      );
    }




   static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    //dyamic 명시적으로 타입이 예상되지 않도록 선언이 가능하다.
     final parts =settings.name.split('?');
     final args =parts.length == 2 ? Uri.splitQueryString(parts[1]) :null;
     switch (parts[0]){
       case'/join':
         //return MaterialPageRoute(settings: settings, builder: (_)=> JoinPage())
     }

  }
}



