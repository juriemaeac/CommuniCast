import 'package:flutter/material.dart';
import 'package:ira/auth/login.dart';
import 'package:ira/auth/signup.dart';
import 'package:ira/constants.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/ira_logo.png')),
              SizedBox(height: 20),
              Text(
                'Welcome to IRA',
                style: AppTextStyles.title,
              ),
              Text(
                'Local Safety Awareness App',
                style: AppTextStyles.body,
              ),
              SizedBox(height: 20),
              Text(
                'Please login or sign up to continue',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: Text('Sign in')),
                  SizedBox(width: 20),
                  Text('or'),
                  SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()));
                      },
                      child: Text('Sign up')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
