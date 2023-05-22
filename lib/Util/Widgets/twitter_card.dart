import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TwitterCard extends StatelessWidget {
  const TwitterCard({
    super.key,
    required this.width,
    required this.height,
    required this.image,
    required this.title,
  });

  final double width;
  final double height;

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.34,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            height: height * 0.12,
            width: width * 0.33,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 0.3, color: Colors.black54),
              image: DecorationImage(
                image: NetworkImage(
                  image,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Scaffold(
              bottomNavigationBar: Text(
                "8:00PM - 9:00PM",
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.31,
                    child: Text(
                      title,
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}