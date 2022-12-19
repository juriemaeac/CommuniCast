import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wesafe/constants.dart';
import 'package:wesafe/resources/auth_methods.dart';
import 'package:wesafe/resources/firestore_methods.dart';
import 'package:wesafe/screens/login_screen.dart';
import 'package:wesafe/utils/colors.dart';
import 'package:wesafe/utils/global_variable.dart';
import 'package:wesafe/utils/utils.dart';
import 'package:wesafe/widgets/follow_button.dart';
import 'package:wesafe/widgets/like_animation.dart';
import 'package:wesafe/widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: user!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(user!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
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
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                userData['username'],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                    buildStatColumn(followers, "followers"),
                                    buildStatColumn(following, "following"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            user!.uid
                                        ? FollowButton(
                                            text: 'Sign Out',
                                            backgroundColor:
                                                AppColors.blueAccent,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await AuthMethods().signOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen(),
                                                ),
                                              );
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .orderBy("datePublished", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: user!.uid)
                          .get(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return const Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // }

                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (snapshot.data! as dynamic).docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (snapshot.data! as dynamic).docs[index];

                                String indicator = snap['indicator'];
                                var icon = 61242;
                                Color color = Colors.white;

                                if (indicator == 'CODE RED') {
                                  icon = 57912;
                                  color = Colors.red;
                                } else if (indicator == 'CODE AMBER') {
                                  icon = 983712;
                                  color = Colors.amber;
                                } else if (indicator == 'CODE BLUE') {
                                  icon = 983744;
                                  color = Colors.blue;
                                } else if (indicator == 'CODE GREEN') {
                                  icon = 983699;
                                  color = Colors.green;
                                } else if (indicator == 'CODE BLACK') {
                                  icon = 62784;
                                  color = Colors.black;
                                }

                                return Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(
                                        color: width > webScreenSize
                                            ? AppColors.greyAccentLine
                                            : AppColors.greyAccentLine,
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: color,
                                            ),
                                            child: Icon(
                                              IconData(
                                                icon,
                                                fontFamily: 'MaterialIcons',
                                              ),
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: width - 70,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(snap['title'],
                                                        style: AppTextStyles
                                                            .body
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    snap['uid'].toString() ==
                                                            user!.uid
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                  useRootNavigator:
                                                                      false,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Dialog(
                                                                      child: ListView(
                                                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                                                          shrinkWrap: true,
                                                                          children: [
                                                                            'Delete',
                                                                          ]
                                                                              .map(
                                                                                (e) => InkWell(
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                      child: Text(e),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      deletePost(
                                                                                        snap['postId'].toString(),
                                                                                      );
                                                                                      // remove the dialog box
                                                                                      Navigator.of(context).pop();
                                                                                    }),
                                                                              )
                                                                              .toList()),
                                                                    );
                                                                  });
                                                            },
                                                            child: Icon(
                                                              Icons.more_vert,
                                                              color:
                                                                  Colors.grey,
                                                              size: 15,
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                                Text(snap['location'],
                                                    style: AppTextStyles.body2
                                                        .copyWith(
                                                      color: Colors.blueAccent,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(snap['description']),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          LikeAnimation(
                                            isAnimating: snap['likes']
                                                .contains(user!.uid),
                                            smallLike: true,
                                            child: GestureDetector(
                                              onTap: () {
                                                FireStoreMethods().likePost(
                                                  snap['postId'].toString(),
                                                  user!.uid,
                                                  snap['likes'],
                                                );
                                              },
                                              child: Icon(
                                                Icons.favorite,
                                                color: snap['likes']
                                                        .contains(user!.uid)
                                                    ? Colors.red
                                                    : Colors.grey,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${snap['likes'].length} likes',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: secondaryColor,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: DateFormat.jm().format(
                                                  snap['datePublished']
                                                      .toDate()),
                                              style: const TextStyle(
                                                color: secondaryColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' • ',
                                            ),
                                            TextSpan(
                                              text: DateFormat.yMMMd().format(
                                                  snap['datePublished']
                                                      .toDate()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
