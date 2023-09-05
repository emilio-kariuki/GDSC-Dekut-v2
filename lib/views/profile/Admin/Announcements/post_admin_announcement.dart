// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/utilities/Widgets/input_field.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Blocs/app_functions_cubit/app_functions_cubit.dart';
import '../../../../data/Services/Providers/providers.dart';

class AdminAnnouncementPostPage extends StatelessWidget {
  AdminAnnouncementPostPage({super.key, required this.tabController});

  final titleController = TextEditingController();
  final nameController = TextEditingController();
  final positionController = TextEditingController();
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppFunctionsCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocListener<AppFunctionsCubit, AppFunctionsState>(
              listener: (context, state) {
                if (state is AnnouncementCreated) {
                  Timer(
                    const Duration(milliseconds: 300),
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF0C7319),
                        content: Text("Announcement Sent Successfully"),
                      ),
                    ),
                  );

                  Providers().createAnnouncementNotification(
                      title: titleController.text,
                      body:
                          "${nameController.text}-${positionController.text}");

                  tabController.animateTo(0);
                }

                if (state is CreateAnnouncementFailed) {
                  Timer(
                    const Duration(milliseconds: 300),
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFFD5393B),
                        content: Text("Failed to create announcement"),
                      ),
                    ),
                  );
                }
              },
              child: BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                builder: (context, state) {
                  return state is AnnouncementCreating
                      ? const LoadingCircle()
                      : SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<AppFunctionsCubit>(context)
                                  .createAnnouncement(
                                title: titleController.text,
                                name: nameController.text,
                                position: positionController.text,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              "Post",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xffffffff),
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                        title: "Title",
                        controller: titleController,
                        hintText: "Enter the title of the announcement"),
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
                        title: "Name",
                        controller: nameController,
                        hintText: "Enter the name of the Sender"),
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
                        title: "Position",
                        controller: positionController,
                        hintText: "Enter the Position of the sender"),
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
