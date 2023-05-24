import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResourceCard extends StatelessWidget {
  const ResourceCard({
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
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.28,
                    height: height * 0.04,
                    child: Text(
                      title,
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
