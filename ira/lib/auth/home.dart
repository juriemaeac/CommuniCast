import 'package:flutter/material.dart';
import 'package:ira/auth/auth.dart';
import 'package:ira/auth/startup.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    if (user != null) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            Text(user.uid),
            Text(user.email ?? 'No email'),
            Text(user.displayName ?? 'No display name'),
            ElevatedButton(
              onPressed: () {
                context.read<FirebaseAuthMethods>().signOut(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const StartupPage();
                }));
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
