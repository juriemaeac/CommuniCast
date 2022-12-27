import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communicast/resources/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:communicast/constants.dart';
import 'package:communicast/responsive/mobile_screen_layout.dart';
import 'package:communicast/responsive/responsive_layout.dart';
import 'package:communicast/responsive/web_screen_layout.dart';
import 'package:communicast/utils/utils.dart';
import 'package:communicast/widgets/text_field_input.dart';

import '../resources/storage_methods.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({super.key});

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  var userData = {};
  Uint8List? _image;
  final TextEditingController _bioController = TextEditingController();

  void update() async {
    await AuthMethods().updateUser(
      bio: _bioController.text,
      file: _image!,
    );
  }

  //get user details
  Future<void> getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final doc = await userRef.get();

    if (doc.exists) {
      setState(() {
        _bioController.text = doc['bio'];
        userData = doc.data()!;
      });
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    print(userData);
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
                  GestureDetector(
                    onTap: selectImage,
                    child: Container(
                      height: 80,
                      width: 80,
                      color: AppColors.greyAccent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          userData['photoUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
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
              //button
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
