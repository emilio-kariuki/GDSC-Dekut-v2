import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/app_functions_cubit/app_functions_cubit.dart';
import 'package:gdsc_bloc/Blocs/event_bloc/event_bloc.dart';
import 'package:gdsc_bloc/utilities/Widgets/admin_past_event.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/utilities/image_urls.dart';
import 'package:gdsc_bloc/views/profile/Admin/Event/edit_event_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class PastEvents extends StatelessWidget {
  PastEvents({super.key, required this.tabController});

  final searchController = TextEditingController();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final venueController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final dateController = TextEditingController();
  final linkController = TextEditingController();
  final organizersController = TextEditingController();
  final imageController = TextEditingController();
  final TabController tabController;

  _editEventDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return EditEventDialog(
            tabController: tabController,
            imageController: imageController,
            idController: idController,
            nameController: nameController,
            descriptionController: descriptionController,
            venueController: venueController,
            organizersController: organizersController,
            linkController: linkController,
            dateController: dateController,
            startTimeController: startTimeController,
            context: context,
            endTimeController: endTimeController);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventBloc()..add(GetPastEvents()),
        ),
        BlocProvider(
          create: (context) => AppFunctionsCubit(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      BlocProvider.of<EventBloc>(context).add(GetPastEvents());
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
                    Row(
                      children: [
                        Expanded(
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
                                  child: TextFormField(
                                    controller: searchController,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: const Color(0xff000000),
                                    ),
                                    onFieldSubmitted: (value) {
                                      BlocProvider.of<EventBloc>(context)
                                          .add(SearchPastEvent(query: value));
                                    },
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          height: 49,
                          width: 49,
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<EventBloc>(context)
                                  .add( GetPastEvents());
                            },
                            style: ElevatedButton.styleFrom(
                              padding:EdgeInsets.zero,
                              elevation: 0,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: const BorderSide(
                                  width: 0.4,
                                  color: Colors.black
                                )
                              ),
                            ),
                            child: const Icon(
                              Icons.refresh,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
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
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                    IconButton(
                                        style: IconButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<EventBloc>(context)
                                              .add(GetPastEvents());
                                          searchController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                                BlocListener<AppFunctionsCubit,
                                        AppFunctionsState>(
                                    listener: (context, appState) {
                                      if (appState is EventStarted) {
                                        tabController.animateTo(0);
                                      }
                                      if (appState is EventDeleted) {
                                        tabController.animateTo(0);
                                      }
                                      if (appState is EventFetched) {
                                        idController.text = appState.event.id!;
                                        imageController.text =
                                            appState.event.imageUrl!;
                                        nameController.text =
                                            appState.event.title!;
                                        descriptionController.text =
                                            appState.event.description!;
                                        venueController.text =
                                            appState.event.venue!;
                                        organizersController.text =
                                            appState.event.organizers!;
                                        linkController.text =
                                            appState.event.link!;
                                        dateController.text =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    appState.event.date!
                                                        .millisecondsSinceEpoch)
                                                .toString();
                                        startTimeController.text =
                                            appState.event.startTime;
                                        endTimeController.text =
                                            appState.event.endTime;
                                        _editEventDialog(context);
                                      }
                                    },
                                    child: state.events.isEmpty
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
                                                    color:
                                                        const Color(0xff666666),
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
                                              return AdminPastEventCard(
                                                id: state.events[index].id ??
                                                    "",
                                                width: width,
                                                height: height,
                                                title:
                                                    state.events[index].title ??
                                                        "",
                                                about: state.events[index]
                                                        .description ??
                                                    "",
                                                date: dateString,
                                                organizers: state.events[index]
                                                        .organizers ??
                                                    "",
                                                venue:
                                                    state.events[index].venue ??
                                                        "",
                                                link:
                                                    state.events[index].link ??
                                                        "",
                                                time:
                                                    "//${state.events[index].startTime} - ${state.events[index].endTime}",
                                                image: state.events[index]
                                                        .imageUrl ??
                                                    AppImages.eventImage,
                                                function: () async {
                                                  BlocProvider.of<
                                                              AppFunctionsCubit>(
                                                          context)
                                                      .fetchEvent(
                                                          id: state
                                                              .events[index]
                                                              .id!);
                                                },
                                                completeFunction: () {
                                                  BlocProvider.of<
                                                              AppFunctionsCubit>(
                                                          context)
                                                      .startEvent(
                                                          id: state
                                                              .events[index]
                                                              .id!);
                                                },
                                                deleteFunction: () {
                                                  BlocProvider.of<
                                                              AppFunctionsCubit>(
                                                          context)
                                                      .deleteEvent(
                                                          id: state
                                                              .events[index]
                                                              .id!);
                                                },
                                              );
                                            },
                                          )),
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
                                      child: BlocListener<AppFunctionsCubit,
                                              AppFunctionsState>(
                                          listener: (context, appState) {
                                            if (appState is EventStarted) {
                                              tabController.animateTo(0);
                                            }
                                            if (appState is EventDeleted) {
                                              tabController.animateTo(0);
                                            }
                                            if (appState is EventFetched) {
                                              idController.text =
                                                  appState.event.id!;
                                              imageController.text =
                                                  appState.event.imageUrl!;
                                              nameController.text =
                                                  appState.event.title!;
                                              descriptionController.text =
                                                  appState.event.description!;
                                              venueController.text =
                                                  appState.event.venue!;
                                              organizersController.text =
                                                  appState.event.organizers!;
                                              linkController.text =
                                                  appState.event.link!;
                                              dateController.text = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          appState.event.date!
                                                              .millisecondsSinceEpoch)
                                                  .toString();
                                              startTimeController.text =
                                                  appState.event.startTime;
                                              endTimeController.text =
                                                  appState.event.endTime;
                                              _editEventDialog(context);
                                            }
                                          },
                                          child: state.events.isEmpty
                                              ? SizedBox(
                                                  height: height * 0.5,
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Lottie.asset(
                                                          AppImages.oops,
                                                          height: height * 0.2),
                                                      Text(
                                                        "Search not found",
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15,
                                                          color: const Color(
                                                              0xff666666),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                )
                                              : ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      state.events.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final Timestamp timestamp =
                                                        state.events[index]
                                                            .date!;

                                                    final DateTime dateTime =
                                                        timestamp.toDate();

                                                    // final String dateString =
                                                    //     DateFormat.yMMMMd().format(dateTime);

                                                    final String dateString =
                                                        DateFormat.MMMEd()
                                                            .format(dateTime);
                                                    return AdminPastEventCard(
                                                      id: state.events[index]
                                                              .id ??
                                                          "",
                                                      width: width,
                                                      height: height,
                                                      title: state.events[index]
                                                              .title ??
                                                          "",
                                                      about: state.events[index]
                                                              .description ??
                                                          "",
                                                      date: dateString,
                                                      organizers: state
                                                              .events[index]
                                                              .organizers ??
                                                          "",
                                                      venue: state.events[index]
                                                              .venue ??
                                                          "",
                                                      link: state.events[index]
                                                              .link ??
                                                          "",
                                                      time:
                                                          "//${state.events[index].startTime} - ${state.events[index].endTime}",
                                                      image: state.events[index]
                                                              .imageUrl ??
                                                          AppImages.eventImage,
                                                      function: () async {
                                                        BlocProvider.of<
                                                                    AppFunctionsCubit>(
                                                                context)
                                                            .fetchEvent(
                                                                id: state
                                                                    .events[
                                                                        index]
                                                                    .id!);
                                                      },
                                                      completeFunction: () {
                                                        BlocProvider.of<
                                                                    AppFunctionsCubit>(
                                                                context)
                                                            .startEvent(
                                                                id: state
                                                                    .events[
                                                                        index]
                                                                    .id!);
                                                      },
                                                      deleteFunction: () {
                                                        BlocProvider.of<
                                                                    AppFunctionsCubit>(
                                                                context)
                                                            .deleteEvent(
                                                                id: state
                                                                    .events[
                                                                        index]
                                                                    .id!);
                                                      },
                                                    );
                                                  },
                                                )),
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
