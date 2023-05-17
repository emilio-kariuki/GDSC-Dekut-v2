import 'package:flutter/material.dart';
import 'package:gdsc_bloc/Data/providers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
      ),
      body:  Center(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/login');
            Providers().logoutAccount();
          },
          child: const Text("Profile Page")),
      ),
    );
  }
}