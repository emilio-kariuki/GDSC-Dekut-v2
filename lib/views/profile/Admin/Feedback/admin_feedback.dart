import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/app_functions_cubit/app_functions_cubit.dart';

import 'package:gdsc_bloc/utilities/Widgets/admin_feedback_card.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/utilities/image_urls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AppFeedback extends StatelessWidget {
  const AppFeedback({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AppFunctionsCubit()..fetchFeedback(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Color(0xff666666), size: 20),
            title: Text(
              "Admin Feedback",
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: const Color(0xff666666),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<AppFunctionsCubit>(context).fetchFeedback();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                  builder: (context, state) {
                    if (state is FeedbackLoading) {
                      return SizedBox(
                        height: height * 0.75,
                        child: const Center(
                          child: LoadingCircle(),
                        ),
                      );
                    } else if (state is FeedbackSuccess) {
                      return state.feedback.isEmpty
                          ? SizedBox(
                              height: height * 0.5,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(AppImages.oops,
                                      height: height * 0.2),
                                  Text(
                                    "feedbacks not found",
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
                                listener: (context, appState) {},
                                builder: (context, appState) {
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.feedback.length,
                                    itemBuilder: (context, index) {
                                      return AdminFeedbackCard(
                                        width: width,
                                        height: height,
                                        title: state.feedback[index].email!,
                                        about: state.feedback[index].feedback!,
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                    } else if (state is GetLeadsFailure) {
                      return SizedBox(
                        height: height * 0.9,
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(AppImages.oops, height: height * 0.2),
                            Text(
                              "feedbacks not found",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: const Color(0xff666666),
                              ),
                            ),
                          ],
                        )),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
