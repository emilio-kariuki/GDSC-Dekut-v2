import 'package:flutter/material.dart';

class ProfilePadding extends StatelessWidget {
  const ProfilePadding({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Divider(
        height: 1,
        thickness: 0.4,
      ),
    );
  }
}