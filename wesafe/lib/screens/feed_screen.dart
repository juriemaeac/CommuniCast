import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wesafe/screens/search_profile_screen.dart';
import 'package:wesafe/screens/search_screen.dart';
import 'package:wesafe/utils/colors.dart';
import 'package:wesafe/utils/global_variable.dart';
import 'package:wesafe/widgets/post_card.dart';
import 'package:wesafe/providers/notifications.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  final user = FirebaseAuth.instance.currentUser;
  Stream<QuerySnapshot<Map<String, dynamic>>> postsStream = FirebaseFirestore
      .instance
      .collection("posts")
      .orderBy("datePublished", descending: true)
      .snapshots();

  notifChecker() {
    postsStream.listen((event) {
      var postUid = event.docs.first.get('uid');
      if (event.docs.isEmpty || postUid == user!.uid) {
        return;
      } else {
        if (event.docs.first.get('notificationSent') == true) {
          return;
        } else {
          Notifications.showNotifications(event.docs.first);
          FirebaseFirestore.instance
              .collection('posts')
              .doc(event.docs.first.id)
              .update({
            'notificationSent': true,
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Notifications.init();
    notifChecker();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: width > webScreenSize ? Colors.white : Colors.white,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Timeline', style: TextStyle(color: Colors.black)),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 500),
                          child: const SearchScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
      body: StreamBuilder(
        stream: postsStream,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
