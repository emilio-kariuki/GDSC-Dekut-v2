import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_bloc/Blocs/AppFuntions/app_functions_cubit.dart';
import 'package:gdsc_bloc/Data/Models/resource_model.dart';
import 'package:gdsc_bloc/Data/repository.dart';
import 'package:gdsc_bloc/Util/Widgets/events_card.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:google_fonts/google_fonts.dart';

class EventPage extends StatelessWidget {
  EventPage({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => AppFunctionsCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: () {
                                BlocProvider.of<AppFunctionsCubit>(context)
                                    .changeTab(index: 4);
                              },
                              child: Container(
                                height: height * 0.06,
                                width: height * 0.06,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 250, 100, 14),
                                    width: 1,
                                  ),
                                  color: Colors.black12,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: SvgPicture.asset(
                                  AppImages.person_white,
                                  height: height * 0.03,
                                  width: width * 0.03,
                                )),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello Emilio👋",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color(0xff000000),
                              ),
                            ),
                            Text(
                              "Welcome to GDSC",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 49,
                      padding: const EdgeInsets.only(left: 15, right: 1),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.grey[500]!,
                            width: 0.8,
                          )),
                      child: TextFormField(
                        controller: searchController,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: const Color(0xff000000),
                        ),
                        decoration: InputDecoration(
                          hintText: "Search for event eg. Flutter",
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xff666666),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Text(
                    //   "Featured Events",
                    //   style: GoogleFonts.inter(
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 17,
                    //     color: const Color(0xff000000),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // SizedBox(
                    //     height: height * 0.16,
                    //     child: CarouselSlider(
                    //         items: [
                    //           SampleExample(height: height, width: width),
                    //           SampleExample(height: height, width: width),
                    //           SampleExample(height: height, width: width),
                    //         ],
                    //         options: CarouselOptions(
                    //           height: height * 0.2,
                    //           aspectRatio: 16 / 10,
                    //           viewportFraction: 1,
                    //           initialPage: 0,
                    //           enableInfiniteScroll: true,
                    //           reverse: false,
                    //           autoPlay: true,
                    //           autoPlayInterval: const Duration(seconds: 3),
                    //           autoPlayAnimationDuration:
                    //               const Duration(milliseconds: 800),
                    //           autoPlayCurve: Curves.fastOutSlowIn,
                    //           enlargeCenterPage: false,
                    //           scrollDirection: Axis.horizontal,
                    //           onPageChanged: (index, reason) {
                    //             context
                    //                 .read<AppFunctionsCubit>()
                    //                 .changeCarousel(index: index);
                    //           },
                    //         ))),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    // Center(
                    //   child: BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                    //     builder: (context, state) {
                    //       return DotsIndicator(
                    //         dotsCount: 3,
                    //         position:
                    //             state is CarouselChanged ? state.index : 0,
                    //       );
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 4,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Upcoming Events",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: const Color(0xff000000),
                          ),
                        ),
                        Text(
                          "See all",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<List<Resource>>(
                        future: Repository().getResources(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              if (snapshot.hasData) {
                                return EventCard(
                                  width: width,
                                  height: height,
                                  title: snapshot.data![index].title ?? "",
                                  about:
                                      snapshot.data![index].description ?? "",
                                  date: "Sat, Oct 15",
                                  time: "09:00 - 09:30 AM",
                                  image: snapshot.data![index].imageUrl ??
                                      AppImages.eventImage,
                                );
                                // return ListTile(
                                //   contentPadding: EdgeInsets.zero,
                                //   leading: CachedNetworkImage(
                                //     height: height * 0.06,
                                //     width: height * 0.06,
                                //     imageUrl: snapshot.data![index].imageUrl ??
                                //         AppImages.eventImage,
                                //     imageBuilder: (context, imageProvider) {
                                //       return Container(
                                //         height: height * 0.06,
                                //         width: height * 0.06,
                                //         decoration: BoxDecoration(
                                //           shape: BoxShape.circle,
                                //           border: Border.all(
                                //               width: 0.3,
                                //               color: Colors.black54),
                                //           image: DecorationImage(
                                //             image: imageProvider,
                                //             fit: BoxFit.cover,
                                //           ),
                                //         ),
                                //       );
                                //     },
                                //   ),
                                //   title: Text(
                                //     snapshot.data![index].title ??
                                //         "Flutter Workshop",
                                //     style: GoogleFonts.inter(
                                //       fontWeight: FontWeight.w500,
                                //       fontSize: 15,
                                //       color: const Color(0xff000000),
                                //     ),
                                //   ),
                                //   subtitle: Text(
                                //     snapshot.data![index].description ?? "GDSC",
                                //     style: GoogleFonts.inter(
                                //       fontWeight: FontWeight.w500,
                                //       fontSize: 12,
                                //       color: const Color(0xff000000),
                                //     ),
                                //   ),
                                // );
                              }
                            },
                          );
                        }),
                    
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Twitter Spaces",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: const Color(0xff000000),
                          ),
                        ),
                        Text(
                          "See all",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: height * 0.17,
                      child: FutureBuilder<List<Resource>>(
                          future: Repository().getResources(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: width * 0.34,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        height: height * 0.11,
                                        width: width * 0.33,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 0.3,
                                              color: Colors.black54),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data![index].imageUrl ??
                                                  AppImages.eventImage,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width * 0.31,
                                            child: Text(
                                              snapshot.data![index].title ??
                                                  "Event Title",
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          // Text(
                                          //   snapshot.data![index].description ??
                                          //       "Event Description",
                                          //   overflow: TextOverflow.clip,
                                          //   maxLines: 1,

                                          //   style: GoogleFonts.inter(
                                          //     fontWeight: FontWeight.w500,
                                          //     fontSize: 12,
                                          //     color: Colors.black,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Announcements",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: const Color(0xff000000),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tech Groups",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: const Color(0xff000000),
                          ),
                        ),
                        Text(
                          "See all",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: const Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing:  1,
                              crossAxisSpacing: 8),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: height * 0.1,
                              width: width * 0.33,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.3, color: Colors.black54),
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    AppImages.eventImage,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "GDSC",
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class SampleExample extends StatelessWidget {
  const SampleExample({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.17,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 106, 81, 81),
          width: 0.1,
        ),
        borderRadius: BorderRadius.circular(5),
        image: const DecorationImage(
          image: CachedNetworkImageProvider(
            AppImages.eventImage,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// body: StreamBuilder<List<Event>>(
      //   stream: Repository().getEvents(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     return ListView.builder(
      //       itemCount: snapshot.data?.length,
      //       itemBuilder: (context, index) {
      //         final event = snapshot.data![index];
      //         return ListTile(
      //           title: Text(event.title!),
      //           subtitle: Text(event.venue!),
      //         );
      //       },
      //     );
      //   },
      // )