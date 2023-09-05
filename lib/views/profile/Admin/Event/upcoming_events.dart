import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/app_functions_cubit/app_functions_cubit.dart';
import 'package:gdsc_bloc/Blocs/event_bloc/event_bloc.dart';

import 'package:gdsc_bloc/utilities/Widgets/admin_event_card.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/utilities/image_urls.dart';
import 'package:gdsc_bloc/views/profile/Admin/Event/edit_event_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';



class UpComingEvents extends StatelessWidget {
  UpComingEvents({super.key, required this.tabController});

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
            context: context,
            startTimeController: startTimeController,
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
          create: (context) => EventBloc()..add(GetEvents()),
        ),
        BlocProvider(
          create: (context) => AppFunctionsCubit(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<EventBloc>(context).add(GetEvents());
              return Future.value();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                          .add(SearchEvent(query: value));
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
                                  .add( GetEvents());
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
                                              .add(GetEvents());
                                          searchController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.black,
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
                                                color: const Color(0xff666666),
                                              ),
                                            ),
                                          ],
                                        )),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: BlocConsumer<AppFunctionsCubit,
                                            AppFunctionsState>(
                                          listener: (context, appState) {
                                            if (appState is EventCompleted) {
                                            tabController.animateTo(1);
                                          }
                                          if (appState is EventStarted) {
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
                                              BlocProvider.value(
                                                value: BlocProvider.of<
                                                    AppFunctionsCubit>(context),
                                                child:
                                                    _editEventDialog(context),
                                              );
                                            }
                                            if (appState is EventCompleted) {
                                              BlocProvider.of<EventBloc>(
                                                      context)
                                                  .add(GetEvents());
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      const Color(0xFF085D06),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  content: Center(
                                                    child: Text(
                                                      "Event Completed",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          builder: (context, appState) {
                                            return ListView.builder(
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
                                                return AdminOngoingEventCard(
                                                  id: state.events[index].id ??
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
                                                  link: state
                                                          .events[index].link ??
                                                      "",
                                                  time:
                                                      "${state.events[index].startTime} - ${state.events[index].endTime}",
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
                                                        .completeEvent(
                                                            id: state
                                                                .events[index]
                                                                .id!);
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      )
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
                                      child: BlocConsumer<AppFunctionsCubit,
                                          AppFunctionsState>(
                                        listener: (context, appState) {
                                          if (appState is EventCompleted) {
                                            tabController.animateTo(1);
                                          }
                                          if (appState is EventStarted) {
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
                                            appState.event.date!.toString();
                                            startTimeController.text =
                                                appState.event.startTime;
                                            endTimeController.text =
                                                appState.event.endTime;
                                            BlocProvider.value(
                                              value: BlocProvider.of<
                                                  AppFunctionsCubit>(context),
                                              child: _editEventDialog(context),
                                            );
                                          }
                                        },
                                        builder: (context, appState) {
                                          return state.events.isEmpty
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
                                                        "events not found",
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
                                                    return AdminOngoingEventCard(
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
                                                          "${state.events[index].startTime} - ${state.events[index].endTime}",
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
                                                            .completeEvent(
                                                                id: state
                                                                    .events[
                                                                        index]
                                                                    .id!);
                                                      },
                                                    );
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
