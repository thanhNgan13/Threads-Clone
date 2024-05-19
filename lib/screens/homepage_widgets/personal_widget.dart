import 'package:flutter/material.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal '),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
                Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        Text('UserName',style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Spacer(),
                    CircleAvatar(minRadius: 30,),
                  ],
                ),
                Text('User Biography'),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: TextButton(
                        onPressed:(){showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Alert Dialog"),
                              content: Text("This is an alert dialog."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Close"),
                                ),
                              ],
                            );
                          },
            );},
                        child: Text('Edit profile'),
                      ),
                  ),
                  Expanded(
                      child: TextButton(
                        onPressed:(){ },
                        child: Text('Share profile'),
                      ),
                  ),
              ],
            ),
          
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(tabs: [
                    Tab(text: 'Thread'), // Tab thứ nhất
                        Tab(text: 'Thread replied'), // Tab thứ hai
                        Tab(text: 'Reup posts'), 
                  ]),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Center(
                          child:Text('Thread content'),
                        ),
                        Center(
                          child:Text('Thread replied content'),
                        ),
                        Center(
                          child:Text('Reup posts content'),
                        ),
                      ],
                    )
                  )
              ],),
            )
            )
        ] 
      ),
    );
  }
}
