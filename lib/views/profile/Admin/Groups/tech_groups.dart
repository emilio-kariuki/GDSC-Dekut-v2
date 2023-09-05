import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/app_functions_cubit/app_functions_cubit.dart';

import 'package:gdsc_bloc/utilities/Widgets/admin_groups_card.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/utilities/image_urls.dart';
import 'package:gdsc_bloc/views/profile/Admin/Groups/edit_group_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:gdsc_bloc/Blocs/event_bloc/event_bloc.dart';

class AppGroupsTab extends StatelessWidget {
  AppGroupsTab({super.key, required this.tabController});

  final searchController = TextEditingController();
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  final imageController = TextEditingController();

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventBloc()..add(GetGroups()),
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
              BlocProvider.of<EventBloc>(context).add(GetGroups());
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
                                          .add(SearchGroup(query: value));
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Search for group eg. Flutter",
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
                                  .add(GetGroups());
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: const BorderSide(
                                      width: 0.4, color: Colors.black)),
                            ),
                            child: const Icon(
                              Icons.refresh,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    BlocListener<EventBloc, EventState>(
                      listener: (context, state) {
                        if (state is SearchGroupsFailure) {
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
                          if (state is SearchGroupsLoading) {
                            return SizedBox(
                              height: height * 0.65,
                              child: const Center(
                                child: LoadingCircle(),
                              ),
                            );
                          } else if (state is SearchGroupsSuccess) {
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
                                              .add(const GetAllResource());

                                          searchController.clear();
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                                state.groups.isEmpty
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
                                            if (appState is FetchGroupSuccess) {
                                              idController.text =
                                                  appState.group.id!;
                                              imageController.text =
                                                  appState.group.imageUrl!;
                                              idController.text =
                                                  appState.group.id!;
                                              nameController.text =
                                                  appState.group.title!;
                                              descriptionController.text =
                                                  appState.group.description!;
                                              linkController.text =
                                                  appState.group.link!;
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return EditGroupDialog(
                                                    descriptionController:
                                                        descriptionController,
                                                    tabController:
                                                        tabController,
                                                    imageController:
                                                        imageController,
                                                    idController: idController,
                                                    nameController:
                                                        nameController,
                                                    linkController:
                                                        linkController,
                                                    context: context,
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          builder: (context, appState) {
                                            return state.groups.isEmpty
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
                                                            height:
                                                                height * 0.2),
                                                        Text(
                                                          "groups not found",
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
                                                        state.groups.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return AdminGroupsCard(
                                                        id: state.groups[index]
                                                                .id ??
                                                            "",
                                                        about: state
                                                                .groups[index]
                                                                .description ??
                                                            "",
                                                        width: width,
                                                        height: height,
                                                        title: state
                                                                .groups[index]
                                                                .title ??
                                                            "",
                                                        link: state
                                                                .groups[index]
                                                                .link ??
                                                            "",
                                                        image: state
                                                                .groups[index]
                                                                .imageUrl ??
                                                            AppImages
                                                                .eventImage,
                                                        function: () async {
                                                          BlocProvider.of<
                                                                      AppFunctionsCubit>(
                                                                  context)
                                                              .fetchGroup(
                                                                  id: state
                                                                          .groups[
                                                                              index]
                                                                          .id ??
                                                                      "");
                                                        },
                                                        completeFunction: () {
                                                          BlocProvider.of<
                                                                      AppFunctionsCubit>(
                                                                  context)
                                                              .deleteGroup(
                                                                  id: state
                                                                          .groups[
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
                                if (state is GroupsFailure) {
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
                                  if (state is GroupsLoading) {
                                    return SizedBox(
                                        height: height * 0.65,
                                        child: const Center(
                                            child: LoadingCircle()));
                                  } else if (state is GroupsSuccess) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: BlocConsumer<AppFunctionsCubit,
                                          AppFunctionsState>(
                                        listener: (context, appState) {
                                          if (appState is FetchGroupSuccess) {
                                            idController.text =
                                                appState.group.id!;
                                            imageController.text =
                                                appState.group.imageUrl!;
                                            idController.text =
                                                appState.group.id!;
                                            nameController.text =
                                                appState.group.title!;
                                            descriptionController.text =
                                                appState.group.description!;
                                            linkController.text =
                                                appState.group.link!;
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return EditGroupDialog(
                                                  descriptionController:
                                                      descriptionController,
                                                  tabController: tabController,
                                                  imageController:
                                                      imageController,
                                                  idController: idController,
                                                  nameController:
                                                      nameController,
                                                  linkController:
                                                      linkController,
                                                  context: context,
                                                );
                                              },
                                            );
                                          }
                                        },
                                        builder: (context, appState) {
                                          return state.groups.isEmpty
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
                                                        "group not found",
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
                                                      state.groups.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return AdminGroupsCard(
                                                      id: state.groups[index]
                                                              .id ??
                                                          "",
                                                      about: state.groups[index]
                                                              .description ??
                                                          "",
                                                      width: width,
                                                      height: height,
                                                      title: state.groups[index]
                                                              .title ??
                                                          "",
                                                      link: state.groups[index]
                                                              .link ??
                                                          "",
                                                      image: state.groups[index]
                                                              .imageUrl ??
                                                          AppImages.eventImage,
                                                      function: () async {
                                                        BlocProvider.of<
                                                                    AppFunctionsCubit>(
                                                                context)
                                                            .fetchGroup(
                                                                id: state
                                                                        .groups[
                                                                            index]
                                                                        .id ??
                                                                    "");
                                                      },
                                                      completeFunction: () {
                                                        BlocProvider.of<
                                                                    AppFunctionsCubit>(
                                                                context)
                                                            .deleteGroup(
                                                                id: state
                                                                        .groups[
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
