import 'package:cached_network_image/cached_network_image.dart';
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
        CachedNetworkImage(
          height: height * 0.13,
          width: width * 0.33,
          placeholder: (context, url) {
            return Container(
              height: height * 0.1,
              width: width * 0.33,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 243, 243),
                  borderRadius: BorderRadius.circular(10)),
            );
          },
          errorWidget: ((context, url, error) {
            return const Icon(
              Icons.error,
              size: 20,
              color: Colors.red,
            );
          }),
          imageUrl: image,
          fit: BoxFit.fitHeight,
          imageBuilder: (context, imageProvider) {
            return AnimatedContainer(
             
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.4, color: const Color(0xff666666)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              duration: const Duration(milliseconds: 500),
            );
          },
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
