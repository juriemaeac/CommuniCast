import 'package:flutter/material.dart';
import 'package:wesafe/widgets/settings_buttons.dart';

class ManageButtons extends StatefulWidget {
  const ManageButtons({super.key});

  @override
  State<ManageButtons> createState() => _ManageButtonsState();
}

class _ManageButtonsState extends State<ManageButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsCard(
          label: 'Change Name',
          navigator: 'changeName',
        ),
        SettingsCard(
          label: 'Change Bio',
          navigator: 'changeBio',
        ),
        SettingsCard(
          label: 'Change Password',
          navigator: 'forgotPassword',
        ),
      ],
    );
  }
}
