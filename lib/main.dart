import 'package:flutter/material.dart';
import 'package:task2/project_list_page.dart';

import 'package:task2/join_page.dart';
import 'package:task2/four04_page.dart';
import 'package:task2/work_page.dart';
//플루터는 widge으로 앱의 화면을 구성한다.

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  //StatelessWidget 변경되지 않는 , 위젯 하위클래스들 : Icon,IconButton,Text
  @override
  //tatelessWidget을 상속하는 Widget은 , "Widget build(BuildContext context)" 를 오버라이딩 해야한다.
  Widget build(BuildContext context){
    //각각의 위젯마다 고유의 BuildContext 가 존재

    return MaterialApp(
      //MaterialApp은 Theme(테마)와 Route(이동)을 담당
      //Text 위젯 , Dropdown 버튼  위젯 , AppBar 위젯 , Scaffold 위젯 , ListView 위젯 , StatelessWidget , StatefulWidget , IconButton 위젯 , TextField 위젯 , Padding 위젯 , ThemeData 위젯
    title:'WinWin Kanban',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(66, 66, 86, 1.0), //앱바 컬러색깔
      ),
      home: ProjectListPage(),
      onGenerateRoute: onGenerateRoute,
      );
    }
   static Route <dynamic> onGenerateRoute(RouteSettings settings) {
    //onGenerateRoute: 앱이 이름이 부여된 라우트를   네비게이팅할 때 호출됨. RouteSettings 가 전달됨
     final parts =settings.name.split('?'); //? 기준으로 앞 0 뒤 1
     print(parts);
     final args =parts.length == 2 ? Uri.splitQueryString(parts[1]) :null;
     String errorMessage ='없는 경로이거나 필수 파라미터가 없습니다.';
     switch (parts[0]){
       case '/join':
         return MaterialPageRoute(settings : settings, builder: (_)  => JoinPage());
       case '/work':
         if(args!=null&& args.containsKey('projectNo')){
           return MaterialPageRoute(builder: (_) =>WorkPage(int.parse(args['projectNo'])));
         }
         return MaterialPageRoute(builder: (_)=>Four04Page(errorMessage));







     }

  }
}





