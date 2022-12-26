import 'package:flutter/material.dart';
import 'package:wesafe/constants.dart';
import 'package:wesafe/widgets/manage_buttons.dart';
import 'package:wesafe/widgets/settings_buttons.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({super.key});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  @override
  Widget build(BuildContext context) {
    List<Route> myRoute = [];
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Manage My Account', style: AppTextStyles.title1),
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ManageButtons(),
        ),
      ),
    );
  }
}
