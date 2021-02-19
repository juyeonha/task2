import 'package:flutter/material.dart';

class WorkPage extends StatefulWidget {
  final int projectNo;
  WorkPage(this.projectNo);

  @override
  _WorkPageState createState() => _WorkPageState();

}

class _WorkPageState extends State<WorkPage> {
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
      title: Text('안녕하세요'),
    );
  }


  Widget _buildBody() {
    return Container(
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Expanded(
        //       child: ReorderableListView(
        //         onReorder: (onIndex, newIndex) {
        //           setState(() {
        //             // _updateWorkItems(oldIndex, newIndex);
        //           });
        //         },
        //         scrollDirection: Axis.horizontal,
        //         // children: [
        //         //   for(WorkListItem item in workList)
        //         // ],
        //
        //       ),
        //     )
        //   ],
        // )
    );
  }
}

void _updateWorkItems(oldIndex, int newIndex) {
}