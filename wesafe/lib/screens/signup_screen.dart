import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wesafe/constants.dart';
import 'package:wesafe/resources/auth_methods.dart';
import 'package:wesafe/responsive/mobile_screen_layout.dart';
import 'package:wesafe/responsive/responsive_layout.dart';
import 'package:wesafe/responsive/web_screen_layout.dart';
import 'package:wesafe/screens/login_screen.dart';
import 'package:wesafe/utils/colors.dart';
import 'package:wesafe/utils/global_variable.dart';
import 'package:wesafe/utils/utils.dart';
import 'package:wesafe/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _confpassController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;
  bool? checkedValue = false;
  bool _isObscure = false;
  bool _isObscure1 = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    if (_birthdateController.text == "" ||
        _usernameController.text == "" ||
        _emailController.text == "" ||
        _firstnameController.text == "" ||
        _lastnameController.text == "" ||
        _passwordController.text == "" ||
        _bioController.text == "") {
      showSnackBar(context, "Please fill all the fields");
      _isLoading = false;
      return;
    } else {
      if (_passwordController.text != _confpassController.text) {
        showSnackBar(context, "Password doesn't match");
        _isLoading = false;
        return;
      } else if (_confpassController.text == "") {
        showSnackBar(context, "Please confirm your password");
        _isLoading = false;
        return;
      } else {
        if (_image == null) {
          showSnackBar(context, "Please select an image");
          _isLoading = false;
          return;
        } else {
          String res = await AuthMethods().signUpUser(
            email: _emailController.text,
            firstName: _firstnameController.text,
            lastName: _lastnameController.text,
            birthDate: _birthdateController.text,
            password: _passwordController.text,
            username: _usernameController.text,
            bio: _bioController.text,
            file: _image!,
            context: context,
          );
          // if string returned is sucess, user has been created
          if (res == "success") {
            setState(() {
              _isLoading = false;
            });
            // navigate to the login screen
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 500),
                child: const LoginScreen(),
              ),
            );
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(builder: (context) => const LoginScreen()),
            // );
          } else {
            setState(() {
              _isLoading = false;
            });
            // show the error
            showSnackBar(context, res);
          }
        }
      }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(32),
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40,
                    child: const Image(
                      image: AssetImage('assets/images/CommuniCast.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Create new account',
                  style: AppTextStyles.title,
                ),
                Text(
                  'Please fill in the form to create an account',
                  style: AppTextStyles.subHeadings,
                ),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: AppColors.greyAccent,
                          )
                        : const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/l60Hf.png'),
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
                const SizedBox(
                  height: 15,
                ),
                TextFieldInput(
                  hintText: 'Enter Username',
                  textInputType: TextInputType.text,
                  textEditingController: _usernameController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 39,
                      child: TextFieldInput(
                        hintText: 'Enter Firstname',
                        textInputType: TextInputType.text,
                        textEditingController: _firstnameController,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 39,
                      child: TextFieldInput(
                        hintText: 'Enter Lastname',
                        textInputType: TextInputType.text,
                        textEditingController: _lastnameController,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 39,
                      child: TextFieldInput(
                        hintText: 'Enter Email',
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                        textCapitalization: TextCapitalization.none,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 39,
                      child: TextFormField(
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
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
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
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isObscure,
                  style: AppTextStyles.textFields,
                  decoration: InputDecoration(
                    fillColor: AppColors.greyAccent,
                    filled: true,
                    hintText: 'Enter Password',
                    hintStyle: AppTextStyles.subHeadings,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2),
                    ),
                    suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Required!";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _confpassController,
                  obscureText: !_isObscure1,
                  style: AppTextStyles.textFields,
                  decoration: InputDecoration(
                    fillColor: AppColors.greyAccent,
                    filled: true,
                    hintText: 'Confirm Password',
                    hintStyle: AppTextStyles.subHeadings,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2),
                    ),
                    suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: Icon(_isObscure1
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure1 = !_isObscure1;
                          });
                        }),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Required!";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFieldInput(
                  hintText: 'Enter Bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                  title: Row(
                    children: [
                      Text("I agree to the ", style: AppTextStyles.subHeadings),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => TermsAndConditions(),
                          //   ),
                          // );
                        },
                        child: Text(
                          "Terms and Conditions",
                          style: AppTextStyles.subHeadings.copyWith(
                            color: AppColors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: checkedValue,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (checkedValue == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please agree to the terms and conditions',
                            style: AppTextStyles.body,
                          ),
                        ),
                      );
                    } else {
                      signUpUser();
                    }
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 30.0)),
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
                    children: [
                      !_isLoading
                          ? const Text(
                              'Sign up',
                              style: AppTextStyles.button,
                            )
                          : const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text('Already have an account?',
                          style: AppTextStyles.subHeadings),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 500),
                          child: const LoginScreen(),
                        ),
                      ),
                      child: Container(
                        child: Text(
                          ' Login.',
                          style: AppTextStyles.subHeadings.copyWith(
                            color: AppColors.blueAccent,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
