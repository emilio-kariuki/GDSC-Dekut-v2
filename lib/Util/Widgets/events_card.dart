import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.width,
    required this.height,
    required this.title,
    required this.about,
    required this.date,
    required this.time,
    required this.image,
  });

  final String about;
  final String date;
  final double height;
  final String image;
  final String time;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color.fromARGB(255, 106, 81, 81),
              width: 0.25,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Column(
            //   children: [
            //     const SizedBox(
            //       height: 10,
            //     ),
            //     ClipRRect(
            //         borderRadius: BorderRadius.circular(100),
            //         child: Container(
            //           decoration: BoxDecoration(
            //             border: Border.all(
            //               color: const Color(0xFF686868),
            //               width: 0.5,
            //             ),
            //           ),
            //           child: Image.network(
            //             AppImages.eventImage,
            //             height: 50,
            //             width: 50,
            //             fit: BoxFit.cover,
            //           ),
            //         )),
            //   ],
            // ),
            // SizedBox(
            //   width: width * 0.03,
            // ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    title,
                    maxLines: 2,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    about,
                    maxLines: 2,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      color: const Color(0xff5B5561),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                    child: Row(
                      
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppImages.calendar,
                                  height: height * 0.02,
                                  width: width * 0.02,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  date,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: const Color(0xff5B5561),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppImages.clock,
                              height: height * 0.02,
                              width: width * 0.02,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              time,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xff5B5561),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
