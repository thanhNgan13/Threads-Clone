import 'package:final_exercises/providers/search.state.dart';
import 'package:final_exercises/screens/notification/list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isTap = false;

  Widget upButton(String text) {
    return GestureDetector(
        onTap: () {
          // setState(() {
          //   isTap = true;
          // });
        },
        child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Container(
                height: 35,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ))));
  }

  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu từ Firestore khi khởi tạo widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchState>(context, listen: false).getDataFromFirestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SearchState>(context);
    final list = state.userlist;

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          centerTitle: false,
          title: Text(
            "Activity",
            style: TextStyle(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 20,
            ),
            Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: 20,
                    ),
                    upButton("All"),
                    upButton("Replies"),
                    upButton("Mentions"),
                    upButton("Verify")
                  ],
                )),
            Container(
              height: 20,
            ),
            state.isBusy
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return UserTilePage(
                          user: list![index],
                          isadded: false,
                        );
                      },
                      itemCount: list?.length ?? 0,
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.only(left: 65),
                            child: Container(
                                height: 0.5,
                                color: Color.fromARGB(255, 69, 69, 69),
                                width: MediaQuery.of(context).size.width - 65));
                      },
                    ),
                  )
          ],
        ));
  }
}
