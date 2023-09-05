import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/utilities/Widgets/events_card.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/utilities/image_urls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../Blocs/event_bloc/event_bloc.dart';

class EventsPage extends StatelessWidget {
  EventsPage({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => EventBloc()..add(GetEvents()),
      child: Builder(builder: (context) {
        return Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
            // backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            centerTitle: true,
            title: Text(
              "Events Page",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      BlocProvider.of<EventBloc>(context).add(GetEvents());
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //           height: 20,
                    //         ),
                    Container(
                      height: 49,
                      padding: const EdgeInsets.only(left: 15, right: 1),
                      decoration: BoxDecoration(
                          // color: Colors.white,
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
                            // color: Color(0xff666666),
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: searchController,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: const Color(0xff000000),
                              ),
                              onFieldSubmitted: (value) {
                                BlocProvider.of<EventBloc>(context)
                                    .add(SearchEvent(query: value));
                              },
                              decoration: InputDecoration(
                                hintText: "Search for event eg. Flutter",
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  // color: const Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    BlocListener<EventBloc, EventState>(
                      listener: (context, state) {
                        if (state is SearchEventFailure) {
                          Timer(
                            const Duration(milliseconds: 300),
                            () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: const Color(0xffEB5757),
                                content: Text(state.message),
                              ),
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<EventBloc, EventState>(
                        builder: (context, state) {
                          if (state is SearchEventLoading) {
                            return SizedBox(
                              height: height * 0.65,
                              child: const Center(
                                child: LoadingCircle(),
                              ),
                            );
                          } else if (state is SearchEventSuccess) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Search Results",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        // color: const Color(0xff000000),
                                      ),
                                    ),
                                    IconButton(
                                        style: IconButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<EventBloc>(context)
                                              .add(GetEvents());
                                          searchController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 18,
                                          // color: Colors.black,
                                        ))
                                  ],
                                ),
                                state.events.isEmpty
                                    ? SizedBox(
                                        height: height * 0.5,
                                        child: Center(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Lottie.asset(AppImages.oops,
                                                height: height * 0.2),
                                            Text(
                                              "Search not found",
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                // color: const Color(0xff666666),
                                              ),
                                            ),
                                          ],
                                        )),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: state.events.length,
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
                                                state.events[index].title ?? "",
                                            about: state.events[index]
                                                    .description ??
                                                "",
                                            date: dateString,
                                            organizers: state
                                                    .events[index].organizers ??
                                                "",
                                            venue:
                                                state.events[index].venue ?? "",
                                            link:
                                                state.events[index].link ?? "",
                                            time:
                                                "${state.events[index].startTime} - ${state.events[index].endTime}",
                                            image:
                                                state.events[index].imageUrl ??
                                                    AppImages.eventImage,
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
                          } else {
                            return BlocListener<EventBloc, EventState>(
                              listener: (context, state) {
                                if (state is EventFailure) {
                                  Timer(
                                    const Duration(milliseconds: 300),
                                    () => ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor:
                                            const Color(0xffEB5757),
                                        content: Text(state.message),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: BlocBuilder<EventBloc, EventState>(
                                builder: (context, state) {
                                  if (state is EventLoading) {
                                    return SizedBox(
                                        height: height * 0.65,
                                        child: const Center(
                                            child: LoadingCircle()));
                                  } else if (state is EventSuccess) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: state.events.length,
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
                                                state.events[index].title ?? "",
                                            about: state.events[index]
                                                    .description ??
                                                "",
                                            date: dateString,
                                            organizers: state
                                                    .events[index].organizers ??
                                                "",
                                            venue:
                                                state.events[index].venue ?? "",
                                            time:
                                                "${state.events[index].startTime} - ${state.events[index].endTime}",
                                            image:
                                                state.events[index].imageUrl ??
                                                    AppImages.eventImage,
                                            link:
                                                state.events[index].link ?? "",
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
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            );
                          }
                        },
                      ),
                    )
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
