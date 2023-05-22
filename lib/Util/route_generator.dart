import 'package:flutter/material.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:gdsc_bloc/View/Authentication/forgot_password_page.dart';
import 'package:gdsc_bloc/View/Authentication/login_page.dart';
import 'package:gdsc_bloc/View/Authentication/register_page.dart';
import 'package:gdsc_bloc/View/Authentication/reset_password_page.dart';
import 'package:gdsc_bloc/View/Home/profile_page.dart';
import 'package:gdsc_bloc/View/Pages/events_page.dart';
import 'package:gdsc_bloc/View/Pages/tech_groups_page.dart';
import 'package:gdsc_bloc/View/Pages/twitter_page.dart';
import 'package:gdsc_bloc/View/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/forgot_password':
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case '/reset_password':
        return MaterialPageRoute(builder: (_) => ResetPassword());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case '/events_page':
        return MaterialPageRoute(builder: (_) => EventsPage());
      case '/twitter_page':
        return MaterialPageRoute(builder: (_) => TwitterPage());
        case '/tech_groups_page':
        return MaterialPageRoute(builder: (_) => TechGroupsPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      final height = MediaQuery.of(context).size.height;
      return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black54),
          ),
          body: SizedBox(
            height: height * 0.9,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(AppImages.oops, height: height * 0.2),
                Text(
                  "Page not found",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: const Color(0xff666666),
                  ),
                ),
              ],
            )),
          ));
    });
  }
}
