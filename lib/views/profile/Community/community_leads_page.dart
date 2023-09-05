import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/app_functions_cubit/app_functions_cubit.dart';

import 'package:gdsc_bloc/utilities/Widgets/leads_card.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/utilities/image_urls.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CommunityLeads extends StatelessWidget {
  const CommunityLeads({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AppFunctionsCubit()..getLeads(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Color(0xff666666), size: 20),
            title: Text(
              "Community leads",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: const Color(0xff666666),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
              builder: (context, state) {
                if (state is GetLeadsLoading) {
                  return SizedBox(
                    height: height * 0.65,
                    child: const Center(
                      child: LoadingCircle(),
                    ),
                  );
                } else if (state is GetLeadsSuccess) {
                  return state.leads.isEmpty
                      ? SizedBox(
                          height: height * 0.9,
                          child: Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(AppImages.oops,
                                  height: height * 0.2),
                              Text(
                                "Leads not found",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: const Color(0xff666666),
                                ),
                              ),
                            ],
                          )),
                        )
                      : GridView.builder(
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 0.65),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.leads.length,
                          itemBuilder: (context, index) {
                            final data = state.leads[index];
                            return LeadsCard(
                              width: width,
                              height: height,
                              title: data.name!,
                              image: data.image ?? AppImages.eventImage,
                              role: data.role!,
                            );
                          },
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
                          "Leads not found",
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
        );
      }),
    );
  }
}
