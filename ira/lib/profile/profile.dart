import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ira/auth/auth.dart';
import 'package:ira/auth/startup.dart';
import 'package:ira/constants.dart';
import 'package:ira/profile/editProfile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  String username = '';
  String email = '';
  String firstName = '';
  String lastName = '';
  String firstLetter = '';

  String caption = '';

  bool isLoading = false;

  Future<void> getUserData() async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    setState(() {
      username = userData['username'];
      email = userData['email'];
      firstName = userData['firstName'];
      lastName = userData['lastName'];
      firstLetter = username.substring(0, 1).toUpperCase();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(30),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Profile Page', style: AppTextStyles.title),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfilePage()));
                        },
                        child: Icon(Icons.settings)),
                  ],
                ),
                SizedBox(height: 50),
                Text(username),
                Text(email),
                Text('${firstName} ${lastName}'),
                Text(firstLetter),
                ElevatedButton(
                  onPressed: () {
                    context.read<FirebaseAuthMethods>().signOut(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const StartupPage();
                    }));
                  },
                  child: Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
