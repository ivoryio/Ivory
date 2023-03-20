import 'package:flutter/material.dart';

import '../../widgets/screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: "Profile",
      child: Center(
        child: Text('Profile'),
      ),
    );
  }
}
