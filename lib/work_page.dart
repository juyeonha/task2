import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:task2/api.dart';
import 'package:task2/work_addcard_dialog.dart';
class WorkListData {
  List<WorkListItem> workList;

  WorkListData({this.workList});

  WorkListData.fromJson(Map<String, dynamic> json) {
    if (json['workList'] != null) {
      workList = new List<WorkListItem>();
      json['workList'].forEach((v) {
        workList.add(new WorkListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.workList != null) {
      data['workList'] = this.workList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class WorkListItem{
  int projectNo;
  int workNo;
  String workTitle; //ex)해야할일, 진행중,완료
  String createDate;
  int workOrder;
  List<CardListItem> cardList;

  WorkListItem({this.projectNo, this.workNo, this.workTitle, this.createDate, this.workOrder, this.cardList});

  WorkListItem.fromJson(Map<String, dynamic> json) {
    projectNo = json['projectNo'];
    workNo = json['workNo'];
    workTitle = json['workTitle'];
    createDate = json['createDate'];
    workOrder = json['workOrder'];
    if (json['cardList'] != null) {
      cardList = new List<CardListItem>();
      json['cardList'].forEach((v) {
        cardList.add(new CardListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectNo'] = this.projectNo;
    data['workNo'] = this.workNo;
    data['workTitle'] = this.workTitle;
    data['createDate'] = this.createDate;
    data['workOrder'] = this.workOrder;
    if (this.cardList != null) {
      data['cardList'] = this.cardList.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class CardListItem{
  String cardType='';
  int projectNo;
  int workNo;
  int cardNo;
  String content;
  String createDate;
  int cardOrder;


  CardListItem({this.cardType, this.projectNo, this.workNo, this.cardNo,
    this.content, this.createDate, this.cardOrder});


  CardListItem.fromJson(Map<String, dynamic> json) {
    projectNo = json['projectNo'];
    workNo = json['workNo'];
    cardNo = json['cardNo'];
    content = json['content'];
    createDate = json['createDate'];
    cardOrder = json['cardOrder'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectNo'] = this.projectNo;
    data['workNo'] = this.workNo;
    data['cardNo'] = this.cardNo;
    data['content'] = this.content;
    data['createDate'] = this.createDate;
    data['cardOrder'] = this.cardOrder;
    return data;
  }
}

class WorkPage extends StatefulWidget {
  WorkPage(this.projectNo);
  final int projectNo;

  @override
  _WorkPageState createState() => _WorkPageState();

}

class _WorkPageState extends State<WorkPage> {
  String title = '';
  List<WorkListItem> workList = [];
  WorkListItem item;

  bool isDrag =false;

  void addTargetCard(){
    for(WorkListItem workItem in workList){
      workItem.cardList.add(CardListItem(cardType: 'target', projectNo: workItem.projectNo, workNo: workItem.workNo , cardOrder : workItem.cardList.length));
    }
  }

  void removeTargetCard(){
    for(WorkListItem workItem in workList){
      workItem.cardList.removeWhere((element)=> element.cardType =='target'?true:false);
      //removeWhere workList 목록에서 충족하는 모든 개체를 제거합니다.
      /* List<String> numbers = ['one', 'two', 'three', 'four'];
      numbers.removeWhere((item) => item.length == 3);
      numbers.join(', '); // 'three, four'*/
    }
  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProject();
      loadWorkList();
    });
  }




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
      title: Text('프로젝트'),
      actions: <Widget>[
        IconButton(
          icon:Icon(Icons.add),
          onPressed: (){
            _addCardDialog(context, widget.projectNo); //리스트는 파라마ㅣ
          },
        ),
        IconButton(
          icon:Icon(Icons.delete),
          onPressed: (){

          },
        ),
      ],


      );
  }


  Widget _buildBody() { //전체적인 페이
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: ReorderableListView(  //ReorderableListView 사용자가 드래그화하여 대화식으로 순서를 변경할 수 있는 목록입니다.
              onReorder: (oldIndex, newIndex) { //기본 목록을 섞기 위해 목록 자식이 새 위치에 놓일 때 호출됩니다.
                //ReorderableListView 에서 항목을 목록의 새 위치로 이동하는 데 사용하는 콜백 입니다.
                //구현시 해당 목록 항목을 oldIndex 에서 제거하고 newIndex에 삽입해야합니다.
                setState(() {
                  _updateWorkItems(oldIndex, newIndex);
                });
              },
              scrollDirection: Axis.horizontal,
              children: [
                for(WorkListItem item in workList)
                  _buildWorkCell(item)
              ]
          ),
          )
        ],
      ),
    );
  }

  Widget _buildWorkCell(WorkListItem item) { //리스트 넣을 셀 만들기
    return Container(
      alignment: Alignment.topLeft,
      key: ValueKey(item),
      width: 200,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      color: Colors.blueAccent,
      child: Column(
        children: [
          Text(item.workTitle, style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          SizedBox(height: 8),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.white,
          ),
          SizedBox(height: 8),
          _buildCardList(item) //리스트 목
        ],
      ),
    );
  }


  Widget _buildCardList(WorkListItem workItem) { //리스트 목록
    List<Widget> cardList = [];

    for(CardListItem card in workItem.cardList){
      if(card.cardType =='target'){ //드래그하려고 잡았을경우 cardType이 target이 된다.
        cardList.add(DragTarget<CardListItem>(
          builder: (context, candidateData,rejectDate){
            return Container(
              margin: EdgeInsets.only(top: 4,bottom: 4),
              width: 168, //드래그 할 위치의 사이즈
              height: 60,
              color: Colors.black45, //드래그로 옮길곳 색
              child: Text('',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            );
          },
          onWillAccept: (data){ //위젯 위에서 드롭되면 전달되는 데이터 값을 사용할지를 콜백을 통해 사용할 수 있다.
            return true;
          },
          onAccept: (data){
            _updateCardItems(data, card.workNo, card.cardOrder);
          },
        ));
      }else{
        cardList.add(
            Stack( //여러개의 Text위젯을 함꼐 사용하는 방
              children: [
                Draggable<CardListItem>( //Draggable : DragTarget 에서 드래그 할 수 있는 위젯
                  onDragStarted: (){ //onDragStarted 드래그 가능 항목이 드래그 되기 시작할떄 호출
                    addTargetCard(); //cardType을 target 으로 지정
                    setState(() {
                      isDrag =true;
                    });
                  },
                  onDragCompleted: (){
                    //onDragCompleted  드래그 가능 항목이 DragTarget에 의해 드롭되고 수락될떄 호출
                    setState(() { //이 위젯이 트리에서 제거되고 드래그가 완료되었을떄 드래그가 진행중이라면 이 콜백은 계속 호출됩니다.
                      //이러한 이유로 이 콜백 구현은 콜백을 수신하는 상태가 여전히 트리에 있는지 확인하기 위해 state.mounted를 확인할 수 있습니다.
                      isDrag =false;
                    });
                  },
                  onDragEnd: (details){
                    //드래그 작업 완료한 후 시작되는 이벤트 스트
                    removeTargetCard();
                    setState((){
                      isDrag =false;
                    });
                  },
                  onDraggableCanceled: (velocity,offset){//DragTarget에 의헤 수락되지 않고 드래그 가능 항목이 드롭될때 수
                    //이 함수는 위젯이 트리에서 제거 된 후에 호출 될 수 있습니다. 예를 들어 이 위젯이 트리에서 제거될떄 드래그가 진행 중이고
                    //드래그가 취소 된 경우 이 콜백은 계속호출됩니다. 이런한 이유로 state.mounted를 사
                    setState(() {
                      isDrag =false;
                    });
                  },
                  data: card,
                  feedback: Opacity( //부분적으로 투명하게 만드는 위젯
                      opacity: 0.7, //투명도
                      child: Container(
                        margin: EdgeInsets.only(top: 4,bottom: 4),
                        width: 168,
                        height: 60,
                        color: Colors.blue,
                        child: Text(card.content, style:TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      )
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 4,bottom: 4),
                    width: 168,
                    height: 60,
                    color: Colors.grey,
                    child: Text(card.content, style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
                Visibility( //보일지 숨길지 여부
                  visible: isDrag, //visible 보일지 안보일지  boolean형태의 클래스 isDrag에 의해 결정된다.
                  child: DragTarget<CardListItem>( //DragTarget 의해 수락된 애들
                      builder: (context,candidateData,rejectDate){
                        return Container(
                          margin: EdgeInsets.only(top: 4,bottom: 4),
                          width: 168,
                          height: 60,
                          color: Colors.blue, //드래그 할때 색깔 변경
                          child: Text(card.content, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                        );
                      },
                      onWillAccept: (data){
                        if(data ==card){
                          return false;
                        }
                        return true;
                      },
                      onAccept:(data){ //드래그가 끝나고 수락한 데이터들
                        _updateCardItems(data, card.workNo, card.cardOrder); //workNo ex)해야하는일, 진행중,완료 카드 번호 , cardOrder 리스트 카드 생성순
                        //카드를 옮기면 해당 일의순서와 카드순서가 업데이트 되게 한다. 하지만 저장안됨...
                      }
                  ),
                ),
              ],
            ));
      }
    }
    return Container(
      child: Column(
        children: cardList,
      ),
    );
  }






  void _updateWorkItems(int oldIndex, int newIndex) { //ReorderableListView
    int projectNo =workList[oldIndex].projectNo;
    int workNo =workList[oldIndex].workNo; //workNo 작업목록 번

    var sendIdx =newIndex; //newIndex로

    if(newIndex > oldIndex){ //
      sendIdx =sendIdx -1;  //oldIndex에서 항목을 제거하면 목록이 1만큼 줄어 듭니다. 그래서 길이를 맞춰주기 위해 sendIdx(newIndex)도 -1
    }
    if(newIndex >oldIndex){
      newIndex -= 1;
    }

    final item =workList.removeAt(oldIndex); //oldIndex 제거
    workList.insert(newIndex, item); //-1해준 newIndex를 넣어준다.

    workOrder(projectNo,workNo,sendIdx); // work put
  }

  //_updateCardItems  loadProject loadWorkList 화면 띄우기 위해서 복붙했습니다.

  void _updateCardItems(CardListItem item, int workNo, int cardOrder) {
    //삭제한다.

    for(WorkListItem workItem in workList) {
      workItem.cardList.remove(item);
    }

    //옮긴다.
    WorkListItem targetWorkItem;
    for(WorkListItem workItem in workList) {
      if(workItem.workNo == workNo) {
        targetWorkItem = workItem;
      }
    }

    if(targetWorkItem != null) {
      item.workNo = workNo;
      targetWorkItem.cardList.insert(cardOrder, item);
    }

    setState(() {

    });
  }


  Future<void> loadProject() async {
    String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/project';
    url = url + '?projectNo=' + widget.projectNo.toString();

    var header = {
      'Authorization': window.localStorage['token']
    };

    var res = await Api().get(url, headers: header);

    var data = jsonDecode(res.body);
    if(data['projectList'].length > 0) {
      title = data['projectList'][0]['title'];
    }

    setState(() {
    });
  }

  Future<void> loadWorkList() async {
    String url = 'https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/work';
    url = url + '?projectNo=' + widget.projectNo.toString();

    var header = {
      'Authorization': window.localStorage['token']
    };

    var res = await Api().get(url, headers: header);
    print(res.body);

    var data = WorkListData.fromJson(jsonDecode(res.body));

    workList.clear();
    for(WorkListItem item in data.workList) {
      workList.add(item);
    }

    setState(() {

    });
  }


  Future<void> workOrder(int projectNo, int workNo, int index) async { //put
    //
    String url ='https://bq04eukeic.execute-api.ap-northeast-2.amazonaws.com/live/work';
    var header ={
      'Authorization' : window.localStorage['token']
    };

    var body = {
      'projectNo': projectNo.toString(), //객체가 가지고 있는정보나 값들을 문자열로 만들어 리턴하는 메소드
      'workNo': workNo.toString(),
      'workOrder': index.toString(),
    };
    var res= await Api().put(url,headers:header,body:body);


    setState(() {
      loadWorkList();
    });

  }

  void _addCardDialog(BuildContext context,int projectNo){
    showDialog(
      barrierDismissible: true, //모달 장벽을 탭하여이 경로를 닫을 수 있는지 여부.
        context: context,
      builder: (BuildContext context){
        return WillPopScope( //취소키 방지
          onWillPop: (){
            return Future.value(true);
          },
          child: AddCardDialog(
            projectNo: projectNo,
            workList: workList,
          ),
        );
      }
    ).then((val){
      if (val == 'REFRESH'){ //PorjectEditDialog 페이지에서 완성이되면 loadProejctList페이지를 다시 리로드 해주겠다.
        loadWorkList();
      }
    });

  }



}

