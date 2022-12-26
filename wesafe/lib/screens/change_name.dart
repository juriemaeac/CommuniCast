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

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  Future<void> update() async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    await userRef.update({
      'firstName': _firstnameController.text,
      'lastName': _lastnameController.text,
    });
  }

  //get user details
  Future<void> getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final doc = await userRef.get();
    if (doc.exists) {
      _firstnameController.text = doc['firstName'];
      _lastnameController.text = doc['lastName'];
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
              'Change Name',
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
                    "First Name",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFieldInput(
                hintText: 'First Name',
                textInputType: TextInputType.text,
                textEditingController: _firstnameController,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Last Name",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFieldInput(
                hintText: 'Last Name',
                textInputType: TextInputType.text,
                textEditingController: _lastnameController,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    if (_firstnameController.text == "" ||
                        _lastnameController.text == "") {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text('Fields cannot be empty'),
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
