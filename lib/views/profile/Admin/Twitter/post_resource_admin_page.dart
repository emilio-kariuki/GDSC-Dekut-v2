import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/app_functions_cubit/app_functions_cubit.dart';

import 'package:gdsc_bloc/utilities/Widgets/input_field.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:google_fonts/google_fonts.dart';

class PostAdminSpace extends StatelessWidget {
  PostAdminSpace({super.key, required this.tabController});

  final imageController = TextEditingController();
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final linkController = TextEditingController();
  final dateController = TextEditingController();

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppFunctionsCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar:
              BlocConsumer<AppFunctionsCubit, AppFunctionsState>(
            listener: (context, state) {
              if (state is SpaceCreated) {
                Timer(
                  const Duration(milliseconds: 100),
                  () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      // behavior: SnackBarBehavior.floating,
                      backgroundColor: Color(0xFF0C7319),
                      content: Text("Space created"),
                    ),
                  ),
                );

                tabController.animateTo(0);
              }
            },
            builder: (context, state) {
              return state is SpaceCreating
                  ? const LoadingCircle()
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AppFunctionsCubit>(context)
                                .createSpace(
                              title: nameController.text,
                              link: linkController.text,
                              date: Timestamp.fromDate(
                                DateTime.parse(dateController.text),
                              ),
                              startTime: Timestamp.fromDate(
                                DateTime.parse(startTimeController.text),
                              ),
                              endTime: Timestamp.fromDate(
                                DateTime.parse(endTimeController.text),
                              ),
                              image: imageController.text,
                            );

                            nameController.clear();
                            startTimeController.clear();
                            endTimeController.clear();
                            linkController.clear();
                            dateController.clear();
                            startTimeController.clear();
                            endTimeController.clear();
                            imageController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF000000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            "Create Space",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      ));
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputField(
                    title: "Name",
                    controller: nameController,
                    hintText: "Edit name of twitter space",
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  InputField(
                    title: "Link",
                    controller: linkController,
                    hintText: "Edit link of twitter space",
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  BlocConsumer<AppFunctionsCubit, AppFunctionsState>(
                    listener: (context, state) {
                      if (state is PickDate) {
                        dateController.text =
                            DateTime.fromMillisecondsSinceEpoch(
                                    state.date.millisecondsSinceEpoch)
                                .toString();
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date of Event",
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff000000),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.only(left: 12, right: 1),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.grey[500]!,
                                  width: 1,
                                )),
                            child: TextFormField(
                              onTap: () async {
                                BlocProvider.of<AppFunctionsCubit>(context)
                                    .pickDate(context: context);
                              },
                              controller: dateController,
                              keyboardType: TextInputType.none,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: const Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                hintText: "Pick date",
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Time",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            BlocProvider(
                              create: (context) => AppFunctionsCubit(),
                              child: Builder(builder: (context) {
                                return Container(
                                  height: 50,
                                  padding:
                                      const EdgeInsets.only(left: 12, right: 1),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Colors.grey[500]!,
                                        width: 1,
                                      )),
                                  child: BlocListener<AppFunctionsCubit,
                                      AppFunctionsState>(
                                    listener: (context, state) {
                                      if (state is PickSpaceTime) {
                                        startTimeController.text =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    state.time
                                                        .millisecondsSinceEpoch)
                                                .toString();
                                      }
                                    },
                                    child: TextFormField(
                                      onTap: () async {
                                        BlocProvider.of<AppFunctionsCubit>(
                                                context)
                                            .pickSpaceTime(context: context);
                                      },
                                      controller: startTimeController,
                                      keyboardType: TextInputType.none,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: const Color(0xff000000),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Start time",
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: Colors.grey[400],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End Time",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.only(left: 12, right: 1),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.grey[500]!,
                                    width: 1,
                                  )),
                              child: BlocConsumer<AppFunctionsCubit,
                                  AppFunctionsState>(
                                listener: (context, state) {
                                  if (state is PickSpaceTime) {
                                    endTimeController.text =
                                        DateTime.fromMillisecondsSinceEpoch(
                                                state.time
                                                    .millisecondsSinceEpoch)
                                            .toString();
                                  }
                                },
                                builder: (context, state) {
                                  return TextFormField(
                                    onTap: () async {
                                      BlocProvider.of<AppFunctionsCubit>(
                                              context)
                                          .pickSpaceTime(context: context);
                                    },
                                    controller: endTimeController,
                                    keyboardType: TextInputType.none,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: const Color(0xff000000),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "End time",
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.grey[400],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Attach a File",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BlocProvider(
                    create: (context) => AppFunctionsCubit(),
                    child: Builder(builder: (context) {
                      return BlocConsumer<AppFunctionsCubit, AppFunctionsState>(
                        listener: (context, state) {
                          if (state is ImagePicked) {
                            imageController.text = state.imageUrl;
                            Timer(
                              const Duration(milliseconds: 300),
                              () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Color(0xFF0C7319),
                                  content: Text("Image uploaded"),
                                ),
                              ),
                            );
                          }

                          if (state is ImagePickingFailed) {
                            Timer(
                              const Duration(milliseconds: 100),
                              () => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFFD5393B),
                                  content: Text(state.message),
                                ),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            height: 50,
                            width: 120,
                            child: state is ImageUploading
                                ? const LoadingCircle()
                                : ElevatedButton(
                                    onPressed: () {
                                      BlocProvider.of<AppFunctionsCubit>(
                                              context)
                                          .getImage();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff000000),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      "Attach File",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                          );
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
