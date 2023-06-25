import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_bloc/Blocs/AppFuntions/app_functions_cubit.dart';
import 'package:gdsc_bloc/Blocs/AuthBloc/auth_bloc.dart';
import 'package:gdsc_bloc/Util/Widgets/input_field.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:gdsc_bloc/View/Authentication/login_page.dart';
import 'package:gdsc_bloc/View/home.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Util/Widgets/divider_or.dart';
import '../../Util/Widgets/fade_in_route.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                    
                    Center(
                        child: SvgPicture.asset(
                      AppImages.register,
                      height: height * 0.25,
                      width: width,
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Register",
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
                      title: "Name",
                      controller: nameController,
                      hintText: "Enter your name",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputField(
                      title: "Email",
                      controller: emailController,
                      hintText: "Enter your email",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                      builder: (context, state) {
                        return InputField(
                            title: "Password",
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
                      height: 30,
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is RegisterSuccess) {
                          Timer(
                            const Duration(seconds: 1),
                            () => Navigator.pushReplacementNamed(
                              context,
                              "/home",
                            ),
                          );
                        }

                        if (state is GoogleLoginSuccess) {
                          Timer(
                            const Duration(seconds: 1),
                            () =>  Navigator.pushReplacement(
                        context,
                        FadeInRoute(
                          routeName: "/home",
                          page: Home(),
                        ),
                      )
                          );
                        }

                        if (state is GoogleLoginFailure) {
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

                        if (state is RegisterFailure) {
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
                        return state is RegisterLoading
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
                                    context.read<AuthBloc>().add(
                                          Register(
                                            name: nameController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                          ),
                                        );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff000000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Text(
                                    "Register",
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
                        Text(
                          "Have an account?",
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
                          routeName: "/login",
                          page: LoginPage(),
                        ),
                      );
                          },
                          child: Text(
                            "Sign in",
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
                      height: 25,
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
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<AuthBloc>()
                                        .add(GoogleAuthentication());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 33, 0, 166),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppImages.google, height: 25,),
                                      SizedBox(width: 8,),
                                      Text(
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
          );
        }),
      ),
    );
  }
}
