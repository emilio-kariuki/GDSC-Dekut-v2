import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_bloc/Util/Widgets/divider_or.dart';
import 'package:gdsc_bloc/Util/Widgets/input_field.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:gdsc_bloc/View/Authentication/register_page.dart';
import 'package:gdsc_bloc/View/home.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Blocs/app_functions_cubit/app_functions_cubit.dart';
import '../../Blocs/auth_bloc/auth_bloc.dart';
import '../../Util/Widgets/fade_in_route.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => AppFunctionsCubit(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                        child: SvgPicture.asset(
                      AppImages.login,
                      height: height * 0.3,
                      width: width,
                    )),
                    AutoSizeText(
                      "Login",
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff000000),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    InputField(
                      controller: emailController,
                      hintText: "Enter your email",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                      builder: (context, state) {
                        return InputField(
                            hintText: "Enter your password",
                            obScureText: state is PasswordInvisibile
                                ? true
                                : state is PasswordVisibile
                                    ? false
                                    : true,
                            controller: passwordController,
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
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgot_password');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AutoSizeText(
                            "Forgot Password?",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is LoginSuccess) {
                          Timer(
                            const Duration(milliseconds: 200),
                            () => Navigator.pushReplacementNamed(
                              context,
                              "/home",
                            ),
                          );
                        }

                        if (state is GoogleLoginSuccess) {
                          Timer(
                              const Duration(milliseconds: 200),
                              () => Navigator.pushReplacement(
                                    context,
                                    FadeInRoute(
                                      routeName: "/home",
                                      page: Home(),
                                    ),
                                  ));
                        }

                        if (state is LoginFailure) {
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

                        if (state is GoogleLoginFailure) {
                          Timer(
                              const Duration(milliseconds: 200),
                              () => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xffEB5757),
                                      content: Text(state.message),
                                    ),
                                  ));
                        }
                        return state is LoginLoading
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
                                    if (emailController.text.isEmpty ||
                                        passwordController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor:
                                              const Color(0xffEB5757),
                                          content: Text(
                                              "Please fill all the fields"),
                                        ),
                                      );
                                    } else {
                                      context.read<AuthBloc>().add(
                                            Login(
                                              email: emailController.text,
                                              password: passwordController.text,
                                            ),
                                          );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff000000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: AutoSizeText(
                                    "Login",
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
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
                        AutoSizeText(
                          "Don't have an account?",
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
                            Navigator.push(
                              context,
                              FadeInRoute(
                                routeName: "/register",
                                page: RegisterPage(),
                              ),
                            );
                          },
                          child: AutoSizeText(
                            "Sign Up",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const DividerOr(),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return state is GoogleLoginLoading
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
                                height: 49,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<AuthBloc>()
                                        .add(GoogleAuthentication());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff000000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        AppImages.google,
                                        height: 25,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      AutoSizeText(
                                        "Sign in with Google",
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
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
