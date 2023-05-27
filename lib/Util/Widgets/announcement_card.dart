import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.name,
    required this.position,
  });

  final double height;
  final double width;
  final String title;
  final String name;
  final String position;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromARGB(255, 106, 81, 81),
                width: 0.15,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "$name - $position",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xff5B5561),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),

              // ClipRRect(
              // borderRadius: BorderRadius.circular(10),
              // child: Container(
              //   height: height * 0.15,
              //   width: width * 0.6,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: const Color(0xFF686868),
              //       width: 0.5,
              //     ),
              //   ),
              //   child: Image.network(
              //     AppImages.eventImage,
              //     height: 50,
              //     width: 50,
              //     fit: BoxFit.cover,
              //   ),
              // )),
              // SizedBox(
              //   height: 30,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           SvgPicture.asset(
              //             AppImages.calendar,
              //             height: height * 0.02,
              //             width: width * 0.02,
              //           ),
              //           const SizedBox(
              //             width: 5,
              //           ),
              //           Text(
              //             "Today",
              //             style: GoogleFonts.inter(
              //               fontSize: 14,
              //               color: const Color(0xff5B5561),
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         width: width * 0.2,
              //       ),
              //       Row(
              //         children: [
              //           SvgPicture.asset(
              //             AppImages.clock,
              //             height: height * 0.02,
              //             width: width * 0.02,
              //           ),
              //           const SizedBox(
              //             width: 5,
              //           ),
              //           Text(
              //             "10:00 AM",
              //             style: GoogleFonts.inter(
              //               fontSize: 14,
              //               color: const Color(0xff5B5561),
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
