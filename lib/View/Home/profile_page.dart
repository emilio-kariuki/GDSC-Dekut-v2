import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/AdminCubit/admin_cubit.dart';
import 'package:gdsc_bloc/Data/Repository/providers.dart';
import 'package:gdsc_bloc/Util/Widgets/profile_card.dart';
import 'package:gdsc_bloc/Util/Widgets/profile_padding.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:gdsc_bloc/Util/shared_preference_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Tech Doe";
  String email = "tech@gmail.com";

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    try {
      final userId = await SharedPreferencesManager().getId();
      final user = await Providers().getUser(userId: userId);
      name = user.name!;
      email = user.email!;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => AdminCubit(),
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
                    await Providers().logoutAccount().then(
                        (value) => Navigator.pushNamed(context, "/login"));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.03,
                      ),
                      CachedNetworkImage(
                        imageUrl: AppImages.eventImage,
                        imageBuilder: (context, imageProvider) => Container(
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
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        email,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xff666666),
                        ),
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
                            child: Text(
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
                                  height: 8,
                                ),
                                const ProfilePadding(),
                                ProfileCard(
                                  title: "Profile",
                                  function: () {
                                    Navigator.pushNamed(
                                        context, '/personal_information');
                                  },
                                  showTrailing: true,
                                ),
                                const ProfilePadding(),
                                ProfileCard(
                                  title: "Resources",
                                  function: () {
                                    Navigator.pushNamed(
                                        context, '/user_resources');
                                  },
                                  showTrailing: true,
                                ),
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
                                  height: 8,
                                ),
                                ProfileCard(
                                  title: "community leads",
                                  function: () {
                                    Navigator.pushNamed(
                                        context, '/community_leads');
                                  },
                                  showTrailing: true,
                                ),
                                const ProfilePadding(),
                                BlocConsumer<AdminCubit,
                                    AdminState>(
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
                                            borderRadius: BorderRadius.circular(20)
                                          ),
                                          content: Center(
                                            child: Text(
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
                                      title: "Admin",
                                      function: () {
                                        BlocProvider.of<AdminCubit>(
                                                context)
                                            .checkUserStatus();
                                      },
                                      showTrailing: true,
                                    );
                                  },
                                ),
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
                                  height: 8,
                                ),
                                ProfileCard(
                                  title: "Send Feedback",
                                  function: () {
                                    Navigator.pushNamed(
                                        context, '/send_feedback');
                                  },
                                  showTrailing: true,
                                ),
                                const ProfilePadding(),
                                ProfileCard(
                                  title: "Report problem",
                                  function: () {
                                    Navigator.pushNamed(
                                        context, '/report_problem');
                                  },
                                  showTrailing: true,
                                ),
                                const ProfilePadding(),
                                ProfileCard(
                                  title: "Contact Developer",
                                  function: () {
                                    Navigator.pushNamed(
                                        context, '/contact_developer');
                                  },
                                  showTrailing: true,
                                ),
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
                                  height: 8,
                                ),
                                ProfileCard(
                                  title: "About app",
                                  function: () {
                                    Navigator.pushNamed(context, '/about_app');
                                  },
                                  showTrailing: true,
                                ),
                                const ProfilePadding(),
                                ProfileCard(
                                  title: "Version - 2.0.0",
                                  function: () {},
                                  showTrailing: false,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
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
