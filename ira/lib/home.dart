import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ira/auth/auth.dart';
import 'package:ira/auth/startup.dart';
import 'package:ira/constants.dart';
import 'package:provider/provider.dart';

final postRef = FirebaseFirestore.instance.collection('posts');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';
  String email = '';
  String firstName = '';
  String lastName = '';

  bool isLoading = false;

  List postsList = [];

  Future<void> getUserData() async {
    final user = context.read<User?>();
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    setState(() {
      username = userData['username'];
      email = userData['email'];
      firstName = userData['firstName'];
      lastName = userData['lastName'];
    });
  }

  getPostData() {
    postRef.get().then((QuerySnapshot posts) {
      posts.docs.forEach((postsCol) {
        FirebaseFirestore.instance
            .collection("posts")
            .doc(postsCol.id)
            .collection("userPosts")
            .get()
            .then((QuerySnapshot userPosts) {
          userPosts.docs.forEach((userPostsCol) {
            postsList.add(userPostsCol.data);
          });
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    getPostData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome to IRA', style: AppTextStyles.title),
                Text('This is the home page'),
                SizedBox(height: 50),
                Text(username),
                Text(email),
                Text('${firstName} ${lastName}'),
                Text(postsList.isEmpty.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
