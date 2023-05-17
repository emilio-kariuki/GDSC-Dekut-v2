import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_bloc/Blocs/AppFuntions/app_functions_cubit.dart';
import 'package:gdsc_bloc/Blocs/AuthBloc/auth_bloc.dart';
import 'package:gdsc_bloc/Util/Widgets/input_field.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final emailController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff000000)),
        title: Text(
          'Forgot Password',
          style: GoogleFonts.inter(
            color: const Color(0xff000000),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) => AppFunctionsCubit(),
          ),
        ],
        child: Builder(builder: (context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: height * 0.06,
                    ),
                    Center(
                        child: SvgPicture.asset(
                      AppImages.gdsc,
                      height: height * 0.05,
                      width: width,
                    )),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Text(
                      "Forgot Password",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff000000),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    InputField(
                      title: "Email",
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                      builder: (context, state) {
                        return InputField(
                            title: "Old Password",
                            obScureText: state is PasswordInvisibile
                                ? true
                                : state is PasswordVisibile
                                    ? false
                                    : true,
                            controller: oldPasswordController,
                            suffixIcon: state is PasswordInvisibile
                                ? InkWell(
                                    onTap: () {
                                      context
                                          .read<AppFunctionsCubit>()
                                          .changePasswordVisibility(
                                              isVisible: true);
                                    },
                                    child: const Icon(
                                      Icons.visibility,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  )
                                : state is PasswordVisibile
                                    ? InkWell(
                                        onTap: () {
                                          context
                                              .read<AppFunctionsCubit>()
                                              .changePasswordVisibility(
                                                  isVisible: false);
                                        },
                                        child: const Icon(
                                          Icons.visibility_off,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      )
                                    : Container());
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocProvider(
                      create: (context) => AppFunctionsCubit(),
                      child: Builder(
                        builder: (context) {
                          return BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                            builder: (context, dstate) {
                              return InputField(
                                  title: "New Password",
                                  obScureText: dstate is PasswordInvisibile
                                      ? true
                                      : dstate is PasswordVisibile
                                          ? false
                                          : true,
                                  controller: newPasswordController,
                                  suffixIcon: dstate is PasswordInvisibile
                                      ? InkWell(
                                          onTap: () {
                                            context
                                                .read<AppFunctionsCubit>()
                                                .changePasswordVisibility(
                                                    isVisible: true);
                                          },
                                          child: const Icon(
                                            Icons.visibility,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        )
                                      : dstate is PasswordVisibile
                                          ? InkWell(
                                              onTap: () {
                                                context
                                                    .read<AppFunctionsCubit>()
                                                    .changePasswordVisibility(
                                                        isVisible: false);
                                              },
                                              child: const Icon(
                                                Icons.visibility_off,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                            )
                                          : Container());
                            },
                          );
                        }
                      ),
                    ),
                    
                    const SizedBox(
                      height: 30,
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                          if (state is ResetPasswordSuccess) {
                          Timer(const Duration(seconds: 1), () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                               backgroundColor: Color.fromARGB(255, 31, 165, 83),
                                content: Text("Password Changed Successfully"),
                              ),
                            );
                            Navigator.pushReplacementNamed(
                              context,
                              "/login",
                            );
                          });
                        }
                        if (state is ResetPasswordFailure) {
                          Timer(
                              const Duration(seconds: 1),
                              () => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xffEB5757),
                                      content: Text(state.message),
                                    ),
                                  ));
                        }
                        return state is ResetPasswordLoading
                            ? const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Color(0xff000000),
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<AuthBloc>().add(ChangePassword(
                                        email: emailController.text,
                                        oldPassword: oldPasswordController.text,
                                        newPassword:
                                            newPasswordController.text));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff000000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    "Change Password",
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dont remember your password?",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff000000),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/reset_password");
                          },
                          child: Text(
                            "Reset ",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
