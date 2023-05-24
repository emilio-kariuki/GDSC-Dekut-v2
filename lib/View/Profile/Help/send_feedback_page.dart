import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/AppFuntions/app_functions_cubit.dart';
import 'package:gdsc_bloc/Util/Widgets/input_field.dart';
import 'package:google_fonts/google_fonts.dart';

class SendFeedbackPage extends StatelessWidget {
  SendFeedbackPage({super.key});

  final feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff666666)),
        title: Text(
          "Feedback",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InputField(
              title: "Feedback",
              controller: feedbackController,
              hintText: "Enter your feed",
            ),
            const SizedBox(
              height: 30,
            ),
            BlocProvider(
              create: (context) => AppFunctionsCubit(),
              child: Builder(builder: (context) {
                return BlocListener<AppFunctionsCubit, AppFunctionsState>(
                  listener: (context, state) {
                    if (state is FeedbackSent) {
                      Timer(
                        const Duration(milliseconds: 300),
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xFF0C7319),
                            content: Text("Feedback Sent Successfully"),
                          ),
                        ),
                      );
                    }

                    if (state is FeedbackSendingFailed) {
                      Timer(
                        const Duration(milliseconds: 300),
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
                  child: BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AppFunctionsCubit>(context)
                                .sendFeedBack(
                                    feedback: feedbackController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff000000),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            "Send Feedback",
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
