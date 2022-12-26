import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wesafe/constants.dart';
import 'package:wesafe/responsive/mobile_screen_layout.dart';
import 'package:wesafe/responsive/responsive_layout.dart';
import 'package:wesafe/responsive/web_screen_layout.dart';
import 'package:wesafe/utils/utils.dart';
import 'package:wesafe/widgets/text_field_input.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({super.key});

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  final TextEditingController _bioController = TextEditingController();

  Future<void> update() async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    await userRef.update({
      'bio': _bioController.text,
    });
  }

  //get user details
  Future<void> getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final doc = await userRef.get();
    if (doc.exists) {
      _bioController.text = doc['bio'];
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.white,
            centerTitle: true,
            elevation: 0,
            title: const Text(
              'Change Bio',
              style: AppTextStyles.title1,
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        backgroundColor: AppColors.white,
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Bio",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextField(
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _bioController,
                //style: AppTextStyles.textFields,
                decoration: const InputDecoration(
                  fillColor: AppColors.greyAccent,
                  hintText: 'Bio',
                  hintStyle: AppTextStyles.subHeadings,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.transparent, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    if (_bioController.text == "") {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text('Bio cannot be empty'),
                            );
                          });
                    } else {
                      update();
                      Navigator.of(context).pushAndRemoveUntil(
                          PageTransition(
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 200),
                            child: ResponsiveLayout(
                              mobileScreenLayout: MobileScreenLayout(),
                              webScreenLayout: WebScreenLayout(),
                            ),
                          ),
                          (route) => false);
                    }
                  },
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    // backgroundColor:
                    //     MaterialStateProperty.all<Color>(Colors.blueAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    shadowColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Save',
                        style: AppTextStyles.button,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
