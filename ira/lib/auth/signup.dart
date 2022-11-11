import 'package:flutter/material.dart';
import 'package:ira/auth/auth.dart';
import 'package:ira/auth/login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController companynameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confpassController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    companynameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUp() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
        displayName: companynameController.text,
        email: emailController.text,
        password: passwordController.text,
        context: context);
  }

  bool _isObscure = false;
  bool _isObscure1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'Sign up for an account',
            ),
            TextField(
              controller: companynameController,
              decoration: const InputDecoration(
                hintText: 'Enter Company Name',
                contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                // border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter Email',
                contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                // border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordController,
              obscureText: !_isObscure,
              decoration: InputDecoration(
                hintText: 'Enter Password',
                contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                // border: OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: confpassController,
              obscureText: !_isObscure1,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                // border: OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                suffixIcon: IconButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon: Icon(
                        _isObscure1 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isObscure1 = !_isObscure1;
                      });
                    }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'By Creating an account, you agree to our ',
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Terms of Service and Privacy Policy',
                    ),
                  ),
                ),
                Text(
                  ' and ',
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Privacy Policy',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: signUp,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 30.0)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blueAccent),
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
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
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
