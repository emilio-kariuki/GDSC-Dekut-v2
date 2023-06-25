import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_bloc/Blocs/AnnouncementCubit/announcement_cubit.dart';
import 'package:gdsc_bloc/Blocs/AppFuntions/app_functions_cubit.dart';
import 'package:gdsc_bloc/Blocs/Event/event_bloc.dart';
import 'package:gdsc_bloc/Data/Models/announcement_model.dart';
import 'package:gdsc_bloc/Data/Models/groups_model.dart';
import 'package:gdsc_bloc/Data/Repository/providers.dart';
import 'package:gdsc_bloc/Data/Repository/repository.dart';

import 'package:gdsc_bloc/Util/Widgets/announcement_card.dart';
import 'package:gdsc_bloc/Util/Widgets/category_widget.dart';
import 'package:gdsc_bloc/Util/Widgets/events_card.dart';
import 'package:gdsc_bloc/Util/Widgets/group_container.dart';
import 'package:gdsc_bloc/Util/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/Util/Widgets/not_found.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppFunctionsCubit(),
        ),
        BlocProvider<EventBloc>(
            create: (context) => EventBloc()..add(GetEvents())),
        BlocProvider<AppFunctionsCubit>(
          create: (context) => AppFunctionsCubit()..fetchUser(),
        ),
        BlocProvider<AnnouncementCubit>(
          create: (context) => AnnouncementCubit()..getAnnoucements(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.white,
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  BlocProvider.of<EventBloc>(context).add(GetEvents());
                  BlocProvider.of<AppFunctionsCubit>(context)
                      .getTwitterSpaces();
                  BlocProvider.of<AnnouncementCubit>(context).getAnnoucements();
                  BlocProvider.of<AppFunctionsCubit>(context).fetchUser();
                  return Future.value();
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                              builder: (context, state) {
                                return Semantics(
                                  button: true,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, "/profile");
                                    },
                                    child: Container(
                                      height: height * 0.06,
                                      width: height * 0.06,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 250, 100, 14),
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
                                BlocBuilder<AppFunctionsCubit,
                                    AppFunctionsState>(
                                  builder: (context, state) {
                                    return state is UserFetched
                                        ? Text(
                                            "Hello ${state.user.name}👋",
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: const Color(0xff000000),
                                            ),
                                          )
                                        : Text(
                                            "Hello there👋",
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: const Color(0xff000000),
                                            ),
                                          );
                                  },
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
                            const Spacer(),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/announcement_page');
                              },
                              icon: const Icon(
                                Icons.notifications_active_outlined,
                                size: 24,
                                color: Colors.black,
                              ),
                            )
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
                              padding:
                                  const EdgeInsets.only(left: 15, right: 1),
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
                        const SizedBox(height: 10),
                        StreamBuilder<List<AnnouncementModel>>(
                          stream: Repository().getAnnoucements(),
                          builder: (context, snapshot) {
                            Widget output = const SizedBox.shrink();
                            final data = snapshot.data;
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              output = SizedBox(
                                height: height * 0.2,
                                child: const Center(child: LoadingCircle()),
                              );
                            }
                            if (snapshot.hasData) {
                              output = data!.isEmpty
                                  ? SizedBox.shrink()
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CategoryWidget(
                                          title: "Announcements",
                                          location: '/announcement_page',
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              data.length > 2 ? 2 : data.length,
                                          itemBuilder: (context, index) {
                                            return AnnouncementCard(
                                              id: data[index].id ?? "",
                                              height: height,
                                              width: width,
                                              title: data[index].title ?? "",
                                              name: data[index].name ?? "",
                                              position:
                                                  data[index].position ?? "",
                                            );
                                          },
                                        ),
                                      ],
                                    );
                            }
                            return output;
                          },
                        ),
                        BlocBuilder<EventBloc, EventState>(
                          builder: (context, state) {
                            if (state is EventLoading) {
                              return SizedBox(
                                  height: height * 0.2,
                                  child: const Center(child: LoadingCircle()));
                            } else if (state is EventSuccess) {
                              return state.events.isEmpty
                                  ? SizedBox.shrink()
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CategoryWidget(
                                          title: "Upcoming Events",
                                          location: '/events_page',
                                        ),
                                        ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: 2,
                                          itemBuilder: (context, index) {
                                            final Timestamp timestamp =
                                                state.events[index].date!;

                                            final DateTime dateTime =
                                                timestamp.toDate();

                                            // final String dateString =
                                            //     DateFormat.yMMMMd().format(dateTime);

                                            final String dateString =
                                                DateFormat.MMMEd()
                                                    .format(dateTime);
                                            return EventCard(
                                              width: width,
                                              height: height,
                                              title:
                                                  state.events[index].title ??
                                                      "",
                                              organizers: state.events[index]
                                                      .organizers ??
                                                  "",
                                              venue:
                                                  state.events[index].venue ??
                                                      "",
                                              about: state.events[index]
                                                      .description ??
                                                  "",
                                              date: dateString,
                                              time:
                                                  "${state.events[index].startTime} - ${state.events[index].endTime}",
                                              image: state
                                                      .events[index].imageUrl ??
                                                  AppImages.eventImage,
                                              link: state.events[index].link ??
                                                  "",
                                              function: () async {
                                                // await Providers()
                                                //     .addEventToCalendar(
                                                //   summary:
                                                //       state.events[index].title!,
                                                //   start: state
                                                //       .events[index].startTime,
                                                //   end:
                                                //       state.events[index].endTime,
                                                // );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    );
                            } else if (state is EventFailure) {
                              return SizedBox(
                                  height: height * 0.2,
                                  child: const Center(
                                      child: Text("Something went wrong")));
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        BlocProvider(
                          create: (context) =>
                              AppFunctionsCubit()..getTwitterSpaces(),
                          child: Builder(builder: (context) {
                            return BlocBuilder<AppFunctionsCubit,
                                AppFunctionsState>(
                              builder: (context, state) {
                                if (state is TwitterSpaceLoading) {
                                  return SizedBox(
                                      height: height * 0.65,
                                      child:
                                          const Center(child: LoadingCircle()));
                                } else if (state is TwitterSpaceSuccess) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CategoryWidget(
                                        title: "Twitter Spaces",
                                        location: '/twitter_page',
                                      ),
                                      state.spaces.isEmpty
                                          ? Center(
                                              child: NotFoundCard(
                                                height: height,
                                                width: width,
                                                title: "No spaces found",
                                                body:
                                                    "Incase of any twitter spaces\n they will displayed here",
                                              ),
                                            )
                                          : SizedBox(
                                              height: height * 0.22,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: state.spaces.length,
                                                itemBuilder: (context, index) {
                                                  final Timestamp startTime =
                                                      state.spaces[index]
                                                          .startTime;
                                                  final Timestamp endTime =
                                                      state.spaces[index]
                                                          .endTime;
                                                  final DateTime startDateTime =
                                                      startTime.toDate();
                                                  final DateTime endDateTime =
                                                      endTime.toDate();

                                                  final String startTimeString =
                                                      DateFormat.jm().format(
                                                          startDateTime);
                                                  final String endTimeString =
                                                      DateFormat.jm()
                                                          .format(endDateTime);

                                                  final Timestamp timestamp =
                                                      state.spaces[index]
                                                          .startTime;

                                                  final DateTime dateTime =
                                                      timestamp.toDate();

                                                  // final String dateString =
                                                  //     DateFormat.yMMMMd().format(dateTime);

                                                  final String dateString =
                                                      DateFormat.MMMEd()
                                                          .format(dateTime);
                                                  return TwitterCard(
                                                    time: dateTime,
                                                    width: width,
                                                    height: height,
                                                    title: state.spaces[index]
                                                            .title ??
                                                        "",
                                                    link: state.spaces[index]
                                                            .link ??
                                                        "",
                                                    image: state.spaces[index]
                                                            .image ??
                                                        AppImages.eventImage,
                                                    startTime: startTimeString,
                                                    endTime: endTimeString,
                                                    date: dateString,
                                                  );
                                                },
                                              ),
                                            ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            );
                          }),
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
                                return SizedBox(
                                    height: height * 0.2,
                                    child:
                                        const Center(child: LoadingCircle()));
                              }

                              if (!snapshot.hasData) {
                                return SizedBox(
                                    height: height * 0.2,
                                    child:
                                        const Center(child: LoadingCircle()));
                              }

                              return SizedBox(
                                height: height * 0.18,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: 8,
                                  itemBuilder: ((context, index) {
                                    return Semantics(
                                      button: true,
                                      child: InkWell(
                                        onTap: () async {
                                          await Providers().openLink(
                                              link:
                                                  snapshot.data![index].link!);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: GroupContainer(
                                            height: height,
                                            width: width,
                                            image: snapshot
                                                    .data![index].imageUrl ??
                                                AppImages.eventImage,
                                            title:
                                                snapshot.data![index].title ??
                                                    "Group Name",
                                            link: snapshot.data![index].link ??
                                                "https://www.google.com",
                                          ),
                                        ),
                                      ),
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
            ),
          ),
        );
      }),
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
