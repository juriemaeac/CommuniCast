import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wesafe/constants.dart';
import 'package:wesafe/responsive/mobile_screen_layout.dart';
import 'package:wesafe/responsive/responsive_layout.dart';
import 'package:wesafe/responsive/web_screen_layout.dart';
import 'package:wesafe/screens/about_screen.dart';
import 'package:wesafe/screens/contact_screen.dart';
import 'package:wesafe/screens/feed_screen.dart';
import 'package:wesafe/screens/forgotPass.dart';
import 'package:wesafe/screens/privacy_screen.dart';
import 'package:wesafe/screens/profile_screen.dart';
import 'package:wesafe/screens/tc_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var nameArray = [
    'Change Password',
    'Terms and Conditions',
    'Privacy Policy',
    'Contact Us',
    'About CommuniCast',
  ];
  List<Route> historicalfigures = [
    MaterialPageRoute(builder: (_) => const ForgotPassword()),
    MaterialPageRoute(builder: (_) => const TermsAndCondition()),
    MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
    MaterialPageRoute(builder: (_) => const ContactUsScreen()),
    MaterialPageRoute(builder: (_) => const AboutScreen()),
  ];
  @override
  Widget build(BuildContext context) {
    List<Route> myRoute = [];
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Settings', style: AppTextStyles.title1),
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: nameArray.length,
                  itemBuilder: (BuildContext context, index) {
                    return GestureDetector(
                      child: ListTile(
                        title: Text(
                          nameArray[index],
                          style: AppTextStyles.body,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () {
                          Future.delayed(Duration(milliseconds: 300), () {
                            Navigator.push(context, historicalfigures[index]);
                          });
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                          //   Navigator.push(context, historicalfigures[index]);
                          // });
                          //Navigator.of(context).push(historicalfigures[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
