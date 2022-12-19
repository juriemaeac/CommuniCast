import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wesafe/screens/add_post_screen.dart';
import 'package:wesafe/screens/feed_screen.dart';
import 'package:wesafe/screens/notification_screen.dart';
import 'package:wesafe/screens/profile_screen.dart';
import 'package:wesafe/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
