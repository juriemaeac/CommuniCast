import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wesafe/codes.dart';
import 'package:wesafe/constants.dart';
import 'package:wesafe/models/user.dart' as model;
import 'package:wesafe/providers/user_provider.dart';
import 'package:wesafe/resources/firestore_methods.dart';
import 'package:wesafe/screens/comments_screen.dart';
import 'package:wesafe/screens/search_profile_screen.dart';
import 'package:wesafe/utils/colors.dart';
import 'package:wesafe/utils/global_variable.dart';
import 'package:wesafe/utils/utils.dart';
import 'package:wesafe/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    String indicator = widget.snap['indicator'];
    var icon = 61242;
    Color color = Colors.white;
    String codeTitle = '';
    String codeDescription = '';

    if (indicator == 'CODE RED') {
      icon = 57912;
      color = Colors.red;
      codeTitle = codeRed;
      codeDescription = codeRedDesc;
    } else if (indicator == 'CODE AMBER') {
      icon = 983712;
      color = Colors.amber;
      codeTitle = codeYellow;
      codeDescription = codeYellowDesc;
    } else if (indicator == 'CODE BLUE') {
      icon = 983744;
      color = Colors.blue;
      codeTitle = codeBlue;
      codeDescription = codeBlueDesc;
    } else if (indicator == 'CODE GREEN') {
      icon = 983699;
      color = Colors.green;
      codeTitle = codeGreen;
      codeDescription = codeGreenDesc;
    } else if (indicator == 'CODE BLACK') {
      icon = 62784;
      color = Colors.black;
    }

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        // border: Border.symmetric(
        //   horizontal: BorderSide(
        //     color: width > webScreenSize
        //         ? AppColors.greyAccentLine
        //         : AppColors.greyAccentLine,
        //   ),
        // ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                // CircleAvatar(
                //   radius: 16,
                //   backgroundImage: NetworkImage(
                //     widget.snap['profImage'].toString(),
                //   ),
                // ),
                Container(
                  height: 40,
                  width: 40,
                  color: AppColors.greyAccent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.snap['profImage'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchProfileScreen(
                                uid: widget.snap['uid'],
                              ),
                            ),
                          ),
                          child: Text(widget.snap['username'].toString(),
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Text('${widget.snap['location']}',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.grey,
                            )),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map(
                                          (e) => InkWell(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 16),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .delete_outline_rounded,
                                                      color: Colors.red,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      e,
                                                      style: AppTextStyles.body,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                deletePost(
                                                  widget.snap['postId']
                                                      .toString(),
                                                );
                                                // remove the dialog box
                                                Navigator.of(context).pop();
                                              }),
                                        )
                                        .toList()),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert,
                            color: AppColors.grey, size: 15),
                      )
                    : Container(),
              ],
            ),
          ),
          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () {
              FireStoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // LIKE, COMMENT SECTION OF THE POST
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: GestureDetector(
                    onTap: () {
                      FireStoreMethods().likePost(
                        widget.snap['postId'].toString(),
                        user.uid,
                        widget.snap['likes'],
                      );
                    },
                    child: Icon(
                      Icons.campaign_rounded,
                      color: widget.snap['likes'].contains(user.uid)
                          ? Colors.red
                          : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${widget.snap['likes'].length} casts',
                  style: AppTextStyles.body2,
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.comment_rounded,
                    size: 20,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                          postId: widget.snap['postId'].toString(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    '$commentLen comments',
                    style: AppTextStyles.body2,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: AppColors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              contentPadding: const EdgeInsets.only(
                                  top: 30.0, right: 30, left: 30),
                              //title:
                              content: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            codeTitle,
                                            style: AppTextStyles.title.copyWith(
                                              color: color,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            codeDescription,
                                            style: AppTextStyles.body,
                                            textAlign: TextAlign.justify,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.end,
                                      //     children: [
                                      //       GestureDetector(
                                      //         onTap: () {
                                      //           Navigator.of(context).pop(
                                      //               false); //Will not exit the App
                                      //         },
                                      //         child: Text(
                                      //           'OK',
                                      //           style:
                                      //               AppTextStyles.body.copyWith(
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ]),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                // ignore: deprecated_member_use
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pop(false); //Will not exit the App
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 30.0,
                                      bottom: 20,
                                    ),
                                    child: Text(
                                      'OK',
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                // TextButton(
                                //   child: Text(
                                //     'OK',
                                //     style: TextStyle(
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.blueGrey),
                                //   ),
                                //   onPressed: () {
                                //     Navigator.of(context)
                                //         .pop(false); //Will not exit the App
                                //   },
                                // ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        // margin: const EdgeInsets.only(top: 5.0),
                        width: MediaQuery.of(context).size.width / 3.7,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconData(icon, fontFamily: 'MaterialIcons'),
                              color: AppColors.white,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              indicator,
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['title'],
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.snap['description'],
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      // RichText(
                      //   text: TextSpan(
                      //     style: const TextStyle(color: primaryColor),
                      //     children: [
                      //       TextSpan(
                      //         text: widget.snap['username'].toString(),
                      //         style: AppTextStyles.body2.copyWith(
                      //           color: AppColors.black,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: ' ${widget.snap['description']}',
                      //         style: AppTextStyles.body2.copyWith(
                      //           color: AppColors.black,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),

                //DATE OF POST
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: DateFormat.jm().format(
                                  widget.snap['datePublished'].toDate()),
                            ),
                            const TextSpan(
                              text: ' • ',
                            ),
                            TextSpan(
                              text: DateFormat.yMMMd().format(
                                  widget.snap['datePublished'].toDate()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          const Divider(),
        ],
      ),
    );
  }
}
