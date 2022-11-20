import 'package:flutter/material.dart';
import 'package:ira/auth/auth.dart';
import 'package:ira/auth/login.dart';
import 'package:ira/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confpassController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUp() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
        username: usernameController.text,
        email: emailController.text,
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        password: passwordController.text,
        context: context);
  }

  String? username;
  String? firstName;
  String? lastName;
  String? password;
  String? confpass;

  bool _isObscure = false;
  bool _isObscure1 = false;

  bool? checkedValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.all(30),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height * 0.08,
                  child:
                      Image(image: AssetImage('assets/images/ira_logo.png'))),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Create new account',
              style: AppTextStyles.title,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Please fill in the form below to create an account',
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 35,
                    decoration: BoxDecoration(
                      color: AppColors.greyAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      autofocus: true,
                      controller: firstnameController,
                      style: AppTextStyles.body,
                      decoration: const InputDecoration(
                        labelText: 'Enter First Name',
                        labelStyle: AppTextStyles.body,
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
                      ),
                      onChanged: (value) {
                        setState(() {
                          firstName = value;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Required!";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 35,
                    decoration: BoxDecoration(
                      color: AppColors.greyAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      autofocus: true,
                      controller: lastnameController,
                      style: AppTextStyles.body,
                      decoration: const InputDecoration(
                        labelText: 'Enter Last Name',
                        labelStyle: AppTextStyles.body,
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
                      ),
                      onChanged: (value) {
                        setState(() {
                          lastName = value;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Required!";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.greyAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  fillColor: AppColors.greyAccent,
                  labelText: 'Enter Username',
                  labelStyle: AppTextStyles.body,
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
                    borderSide: BorderSide(color: Colors.transparent, width: 2),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Required!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.greyAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  fillColor: AppColors.greyAccent,
                  labelText: 'Enter Email',
                  labelStyle: AppTextStyles.body,
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
                    borderSide: BorderSide(color: Colors.transparent, width: 2),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Required!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.greyAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: passwordController,
                obscureText: !_isObscure,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  labelStyle: AppTextStyles.body,
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
                    borderSide: BorderSide(color: Colors.transparent, width: 2),
                  ),
                  suffixIcon: IconButton(
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
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
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.greyAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                controller: confpassController,
                obscureText: !_isObscure1,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: AppTextStyles.body,
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
                    borderSide: BorderSide(color: Colors.transparent, width: 2),
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
            ),
            const SizedBox(
              height: 20,
            ),
            CheckboxListTile(
              title: Row(
                children: [
                  Text(
                    "I agree to the ",
                    style: AppTextStyles.body,
                  ),
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
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.blueAccent,
                        fontWeight: FontWeight.bold,
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
              height: 20,
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
                  signUp();
                }
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 30.0)),
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
                  Text(
                    'Sign Up',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            duration: const Duration(milliseconds: 500),
                            child: const LoginPage()));
                  },
                  child: Text(
                    'Sign In',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )));
  }
}
