import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_bloc/Blocs/AppFuntions/app_functions_cubit.dart';
import 'package:gdsc_bloc/Data/Models/event_model.dart';
import 'package:gdsc_bloc/Data/Models/groups_model.dart';
import 'package:gdsc_bloc/Data/Models/resource_model.dart';
import 'package:gdsc_bloc/Data/providers.dart';
import 'package:gdsc_bloc/Data/repository.dart';
import 'package:gdsc_bloc/Util/Widgets/announcement_card.dart';
import 'package:gdsc_bloc/Util/Widgets/category_widget.dart';
import 'package:gdsc_bloc/Util/Widgets/events_card.dart';
import 'package:gdsc_bloc/Util/Widgets/group_container.dart';
import 'package:gdsc_bloc/Util/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/Util/Widgets/twitter_card.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
                        ),
                        
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Semantics(
                      button: true,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/events_page');
                        },
                        child: Container(
                          height: 49,
                          padding: const EdgeInsets.only(left: 15, right: 1),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.grey[500]!,
                                width: 0.8,
                              )),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search,
                                color: Color(0xff666666),
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  "Search for event eg. flutter",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xff666666),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                    const CategoryWidget(
                      title: "Upcoming Events",
                      location: '/events_page',
                    ),

                    FutureBuilder<List<Event>>(
                        future: Repository().getEvent(),
                        builder: (context, snapshot) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const LoadingCircle();
                              }

                              if (!snapshot.hasData) {
                                return const Center(
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.hasData) {
                                final Timestamp startTime =
                                    snapshot.data![index].startTime;
                                final Timestamp endTime =
                                    snapshot.data![index].endTime;
                                final DateTime startDateTime =
                                    startTime.toDate();
                                final DateTime endDateTime = endTime.toDate();

                                final String startTimeString =
                                    DateFormat.jm().format(startDateTime);
                                final String endTimeString =
                                    DateFormat.jm().format(endDateTime);

                                final Timestamp timestamp =
                                    snapshot.data![index].startTime;

                                final DateTime dateTime = timestamp.toDate();

                                // final String dateString =
                                //     DateFormat.yMMMMd().format(dateTime);

                                final String dateString =
                                    DateFormat.MMMEd().format(dateTime);
                                return EventCard(
                                  function: () {},
                                  width: width,
                                  height: height,
                                  title: snapshot.data![index].title ?? "",
                                  about:
                                      snapshot.data![index].description ?? "",
                                  date: dateString,
                                  time: "$startTimeString - $endTimeString",
                                  image: snapshot.data![index].imageUrl ??
                                      AppImages.eventImage,
                                );
                              }
                              return null;
                            },
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),

                    const CategoryWidget(
                      title: "Twitter Spaces",
                      location: '/twitter_page',
                    ),

                    SizedBox(
                      height: height * 0.21,
                      child: FutureBuilder<List<Resource>>(
                          future: Repository().getResources(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return TwitterCard(
                                  width: width,
                                  height: height,
                                  image: snapshot.data![index].imageUrl ??
                                      AppImages.eventImage,
                                  title: snapshot.data![index].title ??
                                      "Event Title",
                                  startTime: "8:00PM",
                                  endTime: "10:00PM",
                                  date: "26, WED",
                                );
                              },
                            );
                          }),
                    ),

                    const SizedBox(height: 25),
                    Text(
                      "Announcements",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: const Color(0xff000000),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AnnouncementCard(
                      height: height,
                      width: width,
                      title:
                          "Todays session is postponed to noon and we will continue next week on monday",
                      name: "Emilio Kariuki",
                      position: "GDSC Lead",
                    ),
                    AnnouncementCard(
                      height: height,
                      width: width,
                      title: "We meet in Rc 18 for the flutter session",
                      name: "Victor Ndaba",
                      position: "Flutter Lead",
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const CategoryWidget(
                      title: "Tech Groups",
                      location: '/tech_groups_page',
                    ),
                    FutureBuilder<List<GroupsModel>>(
                        future: Providers().getGroups(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return SizedBox(
                            height: height * 0.17,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: 4,
                              itemBuilder: ((context, index) {
                                return GroupContainer(
                                  height: height,
                                  width: width,
                                  image: snapshot.data![index].imageUrl ??
                                      AppImages.eventImage,
                                  title: snapshot.data![index].title ??
                                      "Group Name",
                                );
                              }),
                            ),
                          );
                        }),
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
