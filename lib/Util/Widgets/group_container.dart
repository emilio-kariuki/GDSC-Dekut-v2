import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupContainer extends StatelessWidget {
  const GroupContainer({
    super.key,
    required this.height,
    required this.width,
    required this.image,
    required this.title,
  });

  final double height;
  final double width;
  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          height: height * 0.12,
          width: height * 0.13,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.3,
              color: Colors.black54,
            ),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(
                image,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Center(
          child: SizedBox(
            width: width * 0.27,
            child: Text(
              title,
              overflow: TextOverflow.clip,
              maxLines: 2,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
