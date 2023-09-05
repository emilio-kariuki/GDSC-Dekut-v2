import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/utilities/Widgets/profile_card.dart';
import 'package:gdsc_bloc/utilities/Widgets/profile_padding.dart';
import 'package:gdsc_bloc/utilities/image_urls.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Blocs/admin_cubit/admin_cubit.dart';
import '../../Blocs/app_functions_cubit/app_functions_cubit.dart';
import '../../data/Services/Providers/user_providers.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AdminCubit(),
        ),
        BlocProvider(
          create: (context) => AppFunctionsCubit()..fetchUser(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await UserProviders().logoutAccount().then(
                        (value) => Navigator.pushNamedAndRemoveUntil(context,"/login", ModalRoute.withName('/login')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: AutoSizeText(
                    "Log Out",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                 onRefresh: () {
                    return Future.delayed(const Duration(seconds: 1), () {
                      BlocProvider.of<AppFunctionsCubit>(context).fetchUser();
                    });
                  },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                          builder: (context, state) {
                            if (state is UserFetching) {
                              return const Center(
                                  child: SizedBox(
                                height: 20,
                                width: 20,
                                child: RepaintBoundary(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ));
                            } else if (state is UserFetched) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  CachedNetworkImage(
                                    imageUrl:state.user.imageUrl ?? AppImages.eventImage,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(
                                          width: 0.5,
                                          color: Colors.grey[500]!,
                                        ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  AutoSizeText(
                                    state.user.name!,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  AutoSizeText(
                                    state.user.email!,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: const Color(0xff666666),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutoSizeText(
                                "Account",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: const Color(0xff000000),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const ProfilePadding(),
                                  ProfileCard(
                                    leadingLogo: AppImages.person_black,
                                    title: "Profile",
                                    function: () {
                                      Navigator.pushNamed(
                                          context, '/personal_information');
                                    },
                                    showTrailing: true,
                                  ),
                                  const ProfilePadding(),
                                  ProfileCard(
                                    leadingLogo: AppImages.resources_black,
                                    title: "Resources",
                                    function: () {
                                      Navigator.pushNamed(
                                          context, '/user_resources');
                                    },
                                    showTrailing: true,
                                  ),
                                   const ProfilePadding(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileTitle(width: width, title: "Community"),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                   const ProfilePadding(),
                                  ProfileCard(
                                    leadingLogo: AppImages.community_leads,
                                    title: "Community leads",
                                    function: () {
                                      Navigator.pushNamed(
                                          context, '/community_leads');
                                    },
                                    showTrailing: true,
                                  ),
                                  const ProfilePadding(),
                                  BlocConsumer<AdminCubit, AdminState>(
                                    listener: (context, state) {
                                      if (state is UserAdmin) {
                                        Navigator.pushNamed(
                                            context, '/admin_page');
                                      }
                                      if (state is UserNotAdmin) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            content: Center(
                                              child: AutoSizeText(
                                                "You are not an admin",
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      return ProfileCard(
                                        leadingLogo: AppImages.admin,
                                        title: "Admin",
                                        function: () {
                                          BlocProvider.of<AdminCubit>(context)
                                              .checkUserStatus();
                                        },
                                        showTrailing: true,
                                      );
                                    },
                                  ),
                                   const ProfilePadding(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileTitle(
                              width: width,
                              title: "Help",
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                   const ProfilePadding(),
                                  ProfileCard(
                                    leadingLogo: AppImages.feedbackz,
                                    title: "Send Feedback",
                                    function: () {
                                      Navigator.pushNamed(
                                          context, '/send_feedback');
                                    },
                                    showTrailing: true,
                                  ),
                                  const ProfilePadding(),
                                  ProfileCard(
                                    leadingLogo: AppImages.problemz,
                                    title: "Report problem",
                                    function: () {
                                      Navigator.pushNamed(
                                          context, '/report_problem');
                                    },
                                    showTrailing: true,
                                  ),
                                  const ProfilePadding(),
                                  ProfileCard(
                                     leadingLogo: AppImages.contact,
                                    title: "Contact Developer",
                                    function: () {
                                      Navigator.pushNamed(
                                          context, '/contact_developer');
                                    },
                                    showTrailing: true,
                                  ),
                                   const ProfilePadding(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileTitle(width: width, title: "About"),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                   const ProfilePadding(),
                                  ProfileCard(
                                    leadingLogo: AppImages.about,
                                    title: "About app",
                                    function: () {
                                      Navigator.pushNamed(context, '/about_app');
                                    },
                                    showTrailing: true,
                                  ),
                                  const ProfilePadding(),
                                  ProfileCard(
                                    leadingLogo: AppImages.version,
                                    title: "Version - 2.2.0",
                                    function: () {},
                                    showTrailing: false,
                                  ),
                                   const ProfilePadding(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      }),
    );
  }
}

class ProfileTitle extends StatelessWidget {
  const ProfileTitle({
    super.key,
    required this.width,
    required this.title,
  });

  final double width;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10,),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: const Color(0xff000000),
            ),
          ),
        ],
      ),
    );
  }
}
