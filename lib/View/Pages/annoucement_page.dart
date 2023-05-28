import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/AnnouncementCubit/announcement_cubit.dart';
import 'package:gdsc_bloc/Util/Widgets/announcement_card.dart';
import 'package:gdsc_bloc/Util/Widgets/loading_circle.dart';
import 'package:google_fonts/google_fonts.dart';

class AnnouncementPage extends StatelessWidget {
  AnnouncementPage({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => AnnouncementCubit()..getAnnoucements(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              "Annoucement Page",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: RefreshIndicator(
                 onRefresh: () {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        BlocProvider.of<AnnouncementCubit>(context)
                            .getAnnoucements();
                      },
                    );
                  },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: BlocListener<AnnouncementCubit, AnnouncementState>(
                    listener: (context, state) {
                      if (state is AnnouncementFailure) {
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
                    child: BlocBuilder<AnnouncementCubit, AnnouncementState>(
                      builder: (context, state) {
                        if (state is AnnouncementLoading) {
                          return SizedBox(
                              height: height * 0.65,
                              child: const Center(child: LoadingCircle()));
                        } else if (state is AnnouncementSuccess) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.announcements.length,
                              itemBuilder: (context, index) {
                                return AnnouncementCard(
                                  height: height,
                                  width: width,
                                  title: state.announcements[index].title ?? "",
                                  name: state.announcements[index].name ?? "",
                                  position:
                                      state.announcements[index].position ?? "",
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
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
