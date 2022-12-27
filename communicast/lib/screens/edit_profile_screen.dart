import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
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

import '../resources/auth_methods.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Uint8List? _image;
  var userData = {};
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Future<void> update() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   final userRef =
  //       FirebaseFirestore.instance.collection('users').doc(user!.uid);

  //   // final ref = firebase_storage.FirebaseStorage.instance
  //   //     .ref()
  //   //     .child('companyLogo/$companyName/$fileName');
  //   // imageUrl = await ref.getDownloadURL();

  //   await userRef.update({
  //     //'photoUrl': _image,
  //     'username': _usernameController.text,
  //     'email': _emailController.text,
  //     'birthDate': _birthdateController.text,
  //     'firstName': _firstnameController.text,
  //     'lastName': _lastnameController.text,
  //     'bio': _bioController.text,
  //   });
  // }

  void update() async {
    await AuthMethods().updateProfile(
      bio: _bioController.text,
      firstName: _firstnameController.text,
      lastName: _lastnameController.text,
    );
  }

  void updatePic() async {
    await AuthMethods().updatePic(file: _image!);
  }

  //get user details
  Future<void> getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final doc = await userRef.get();
    if (doc.exists) {
      setState(() {
        userData = doc.data()!;
        _usernameController.text = doc['username'];
        _emailController.text = doc['email'];
        _birthdateController.text = doc['birthDate'];
        _firstnameController.text = doc['firstName'];
        _lastnameController.text = doc['lastName'];
        _bioController.text = doc['bio'];
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
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.white,
            centerTitle: true,
            elevation: 0,
            title: const Text(
              'Edit Profile',
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: AppColors.greyAccent,
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            backgroundColor: AppColors.greyAccent,
                          ),
                    Positioned(
                      bottom: -10,
                      left: 60,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Color(0xFF848484),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'Username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'First Name',
                  textInputType: TextInputType.text,
                  textEditingController: _firstnameController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'Last Name',
                  textInputType: TextInputType.text,
                  textEditingController: _lastnameController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime(
                            DateTime.now().year - 18,
                            DateTime.now().month,
                            DateTime.now().day), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      print('confirm $date');
                      setState(() {
                        var dateTime = DateTime.parse(date.toString());
                        var formate1 =
                            "${dateTime.day}-${dateTime.month}-${dateTime.year}";
                        _birthdateController.text = formate1;
                        //textBirthdate = formate1;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  controller: _birthdateController,
                  style: AppTextStyles.textFields,
                  decoration: const InputDecoration(
                    fillColor: AppColors.greyAccent,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                    hintText: 'Birthdate',
                    hintStyle: AppTextStyles.subHeadings,
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    filled: true,
                    suffixIcon: Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF848484),
                    ),
                  ),
                  validator: (var value) {
                    if (value!.isEmpty) {
                      return 'Enter Birthdate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                  hintText: 'Bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    update();
                    updatePic();
                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.topToBottom,
                          duration: const Duration(milliseconds: 200),
                          child: ResponsiveLayout(
                            mobileScreenLayout: MobileScreenLayout(),
                            webScreenLayout: WebScreenLayout(),
                          ),
                        ));
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        )));
  }
}
