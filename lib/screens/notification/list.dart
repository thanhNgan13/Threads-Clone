// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_exercises/component/title_text.dart';
import 'package:final_exercises/models/user.dart';
import 'package:final_exercises/screens/notification/profile.dart';
import 'package:flutter/material.dart';

class UserTilePage extends StatelessWidget {
  UserTilePage({Key? key, required this.user, required this.isadded})
      : super(key: key);
  final UserModel user;
  bool? isadded;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          ProfilePage.getRoute(profileId: user.id!),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: user.profileImageUrl!,
                height: 40,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TitleText(
                    user.username == null ? "" : user.username!,
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    user.username!,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    height: 9,
                  ),
                  Text(
                    "${user.followers!.length.toString()} followers",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isadded!
                      ? Container()
                      : Container(
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
                            "Follow",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
