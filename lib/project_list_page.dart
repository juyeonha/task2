class ProjectListData{
  List<ProjectListItem> projectList; //파라미터를 받아올 리스트 타입 선

}

class ProjectListItem {
  String projectType;
  int projectNo;
  String userId;
  String title;
  String memo;

  ProjectListItem(this.projectType, this.projectNo, this.userId, this.title, this.memo);

  //다트에서는 선택적 매개변수 개념을 도입하여 사용하고 있다.
  //위의 내용을 풀어서쓰면
  // ProjectLIstItem(String title, String memo){ 길기 때문에 짧게
  //   this.title = title;
  //   this.memo = memo;
  // }



}