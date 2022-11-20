import 'package:flutter/material.dart';
import 'package:ira/auth/auth.dart';
import 'package:ira/auth/signup.dart';
import 'package:ira/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() async {
    context.read<FirebaseAuthMethods>().loginWithEmail(
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }

  bool _isObscure = false;

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
              'Login to your account',
              style: AppTextStyles.title,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Log in now to access your account',
              style: AppTextStyles.subtitle,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot Password?',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: login,
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
                    'Login',
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
                  "Doesn't have an account? ",
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 500),
                              child: const SignupPage()));
                    },
                    child: Text(
                      'Sign Up',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
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
