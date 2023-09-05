import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/app_functions_cubit/app_functions_cubit.dart';
import 'package:gdsc_bloc/utilities/Widgets/admin_announcements_card.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/utilities/image_urls.dart';
import 'package:gdsc_bloc/views/profile/Admin/Announcements/edit_announcement_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../Blocs/event_bloc/event_bloc.dart';


class AdminAnnouncementsTab extends StatelessWidget {
  AdminAnnouncementsTab({
    super.key,
  });
  final searchController = TextEditingController();
  final idController = TextEditingController();
  final titleController = TextEditingController();
  final positionController = TextEditingController();
  final nameController = TextEditingController();

  _editEventDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return EditAnnouncementDialog(
          idController: idController,
          nameController: nameController,
          titleController: titleController,
          positionController: positionController,
          context: context,
        );
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
          create: (context) => EventBloc()..add(const GetAllAnnouncements()),
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
              BlocProvider.of<EventBloc>(context)
                  .add(const GetAllAnnouncements());
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
                                          .add(SearchAnnouncement(query: value));
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Search for announcement eg. Flutter",
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
                        
                        SizedBox(
                          height: 49,
                          // width: 49,
                          child: ElevatedButton(
                            onPressed: () {
                             BlocProvider.of<EventBloc>(context).add(const GetAllAnnouncements());
                                  
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
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
                        if (state is SearchAnnouncementFailure) {
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
                          if (state is SearchAnnouncementLoading) {
                            return SizedBox(
                              height: height * 0.65,
                              child: const Center(
                                child: LoadingCircle(),
                              ),
                            );
                          } else if (state is SearchAnnouncementSuccess) {
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
                                              .add(const GetAllAnnouncements());
                                          searchController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                                state.announcements.isEmpty
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
                                            if (appState
                                                is AnnouncementFetched) {
                                              idController.text =
                                                  appState.announcement.id!;
                                              nameController.text =
                                                  appState.announcement.name!;
                                              titleController.text =
                                                  appState.announcement.title!;
                                              positionController.text = appState
                                                  .announcement.position!;
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return EditAnnouncementDialog(
                                                    idController: idController,
                                                    nameController:
                                                        nameController,
                                                    titleController:
                                                        titleController,
                                                    positionController:
                                                        positionController,
                                                    context: context,
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          builder: (context, appState) {
                                            return ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  state.announcements.length,
                                              itemBuilder: (context, index) {
                                                return AnnouncementAdminCard(
                                                  name: state
                                                          .announcements[index]
                                                          .name ??
                                                      "",
                                                  id: state.announcements[index]
                                                          .id ??
                                                      "",
                                                  width: width,
                                                  height: height,
                                                  title: state
                                                          .announcements[index]
                                                          .title ??
                                                      "",
                                                  position: state
                                                          .announcements[index]
                                                          .position ??
                                                      "",
                                                  editFunction: () async {
                                                    BlocProvider.of<
                                                                AppFunctionsCubit>(
                                                            context)
                                                        .fetchAnnouncement(
                                                            id: state
                                                                    .announcements[
                                                                        index]
                                                                    .id ??
                                                                "");
                                                  },
                                                  deleteFunction: () {
                                                    BlocProvider.of<
                                                                AppFunctionsCubit>(
                                                            context)
                                                        .deleteAnnouncement(
                                                            id: state
                                                                    .announcements[
                                                                        index]
                                                                    .id ??
                                                                "");
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
                                if (state is AnnouncementFailure) {
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
                                  if (state is AnnouncementLoading) {
                                    return SizedBox(
                                        height: height * 0.65,
                                        child: const Center(
                                            child: LoadingCircle()));
                                  } else if (state is AnnouncementSuccess) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: BlocConsumer<AppFunctionsCubit,
                                          AppFunctionsState>(
                                        listener: (context, appState) {
                                          if (appState is AnnouncementFetched) {
                                            idController.text =
                                                appState.announcement.id!;
                                            nameController.text =
                                                appState.announcement.name!;
                                            titleController.text =
                                                appState.announcement.title!;
                                            positionController.text =
                                                appState.announcement.position!;
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return EditAnnouncementDialog(
                                                  idController: idController,
                                                  nameController:
                                                      nameController,
                                                  titleController:
                                                      titleController,
                                                  positionController:
                                                      positionController,
                                                  context: context,
                                                );
                                              },
                                            );
                                          }
                                        },
                                        builder: (context, appState) {
                                          return state.announcements.isEmpty
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
                                                        "Announcement not found",
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
                                                  itemCount: state
                                                      .announcements.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return AnnouncementAdminCard(
                                                      name: state
                                                              .announcements[
                                                                  index]
                                                              .name ??
                                                          "",
                                                      id: state
                                                              .announcements[
                                                                  index]
                                                              .id ??
                                                          "",
                                                      width: width,
                                                      height: height,
                                                      title: state
                                                              .announcements[
                                                                  index]
                                                              .title ??
                                                          "",
                                                      position: state
                                                              .announcements[
                                                                  index]
                                                              .position ??
                                                          "",
                                                      editFunction: () async {
                                                        BlocProvider.of<
                                                                    AppFunctionsCubit>(
                                                                context)
                                                            .fetchAnnouncement(
                                                                id: state
                                                                        .announcements[
                                                                            index]
                                                                        .id ??
                                                                    "");
                                                      },
                                                      deleteFunction: () {
                                                        BlocProvider.of<
                                                                    AppFunctionsCubit>(
                                                                context)
                                                            .deleteAnnouncement(
                                                                id: state
                                                                        .announcements[
                                                                            index]
                                                                        .id ??
                                                                    "");
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
