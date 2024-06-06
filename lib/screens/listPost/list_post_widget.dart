import 'package:final_exercises/providers/post.state.dart';
import 'package:final_exercises/screens/listPost/feedpost.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:iconsax/iconsax.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../helper/utility.dart';

class ListPostWidget extends StatefulWidget {
  const ListPostWidget({super.key});

  @override
  State<ListPostWidget> createState() => _ListPostWidgetState();
}

class _ListPostWidgetState extends State<ListPostWidget> {
  ScrollController _scrollController = ScrollController();

  bool isExpanded = false;
  bool showMoreButton = false;

  String imagePath =
      "https://fastly.picsum.photos/id/9/250/250.jpg?hmac=tqDH5wEWHDN76mBIWEPzg1in6egMl49qZeguSaH9_VI";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<PostState>(context, listen: false).getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Lottie.network(
            "https://assets3.lottiefiles.com/packages/lf20_Ht77kFLXYw.json",
            height: 50),
        toolbarHeight: 37,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<PostState>(
        builder: (context, state, child) {
          if (state.isBusy) {
            return Center(child: CircularProgressIndicator());
          } else if (state.feedlist == null || state.feedlist!.isEmpty) {
            return Center(child: Text('No posts available'));
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.feedlist!.length,
                itemBuilder: (context, index) {
                  return FeedPost(
                    postModel: state.feedlist![index],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Container bodyPost(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 0.2,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://www.w3schools.com/w3images/avatar2.png'),
                ),
                Text(
                  "Username",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                ),
                Text(
                  Utility.getdob(DateTime.now().toString()),
                  style:
                      TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
                ),
                Container(
                  width: 5,
                ),
                Icon(Icons.more_horiz, color: Colors.white)
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 55),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bài văn xúc động người đọc bởi cảm xúc chân thành từ chính tình cảm của con dành cho người cha tần tảo của mình. Cô giáo đã chấm cho Hậu 9,5 điểm với lời nhận xét: “Em là một người con ngoan, bài viết của em đã làm cho cô rất xúc động. Điều đáng quý nhất của em là tình cảm chân thực và em có một trái tim nhân hậu. Em đã cho cô một bài học làm người. Mong rằng đây không chỉ là trang văn mà còn là sự hành xử của em trong cuộc đời”. Được biết, thầy Lê Trần Bân, hiệu phó trường THPT Huỳnh Thúc Kháng đã đọc bài văn trong lễ chào cờ đầu tuần, trước toàn trường.',
                      maxLines: isExpanded ? null : 10,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(color: Colors.white),
                    ),
                    InkWell(
                      child: Text(
                        isExpanded ? 'Thu gọn' : 'Xem thêm',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                  ],
                )),
            Container(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                    ),
                    Icon(
                      Iconsax.heart,
                      color: Colors.white,
                      size: 20,
                    ),
                    Container(
                      width: 10,
                    ),
                    Icon(
                      Iconsax.share,
                      color: Colors.white,
                      size: 20,
                    ),
                    Container(
                      width: 10,
                    ),
                    Icon(
                      Iconsax.repeat,
                      color: Colors.white,
                      size: 20,
                    ),
                    Container(
                      width: 10,
                    ),
                    Icon(
                      Iconsax.send_2,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                    ),
                    Text('12 likes', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Text('4 replies', style: TextStyle(color: Colors.grey)),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
