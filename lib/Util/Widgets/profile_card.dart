import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.title,
    required this.function, required this.showTrailing,
  });
  final String title;
  final Function() function;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.white,
        foregroundColor: Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const Spacer(),
          showTrailing
              ? Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[800],
                  size: 15,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
