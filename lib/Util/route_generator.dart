import 'package:flutter/material.dart';
import 'package:gdsc_bloc/Util/Widgets/image_view.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:gdsc_bloc/View/Authentication/forgot_password_page.dart';
import 'package:gdsc_bloc/View/Authentication/login_page.dart';
import 'package:gdsc_bloc/View/Authentication/register_page.dart';
import 'package:gdsc_bloc/View/Authentication/reset_password_page.dart';
import 'package:gdsc_bloc/View/Home/profile_page.dart';
import 'package:gdsc_bloc/View/Pages/annoucement_page.dart';
import 'package:gdsc_bloc/View/Pages/events_page.dart';
import 'package:gdsc_bloc/View/Pages/resource_post_page.dart';
import 'package:gdsc_bloc/View/Pages/tech_groups_page.dart';
import 'package:gdsc_bloc/View/Pages/twitter_page.dart';
import 'package:gdsc_bloc/View/Profile/About/about_page.dart';
import 'package:gdsc_bloc/View/Profile/Account/personal_information_page.dart';
import 'package:gdsc_bloc/View/Profile/Community/community_leads_page.dart';
import 'package:gdsc_bloc/View/Profile/Community/user_resources.dart';
import 'package:gdsc_bloc/View/Profile/Help/contact_developer_page.dart';
import 'package:gdsc_bloc/View/Profile/Help/report_problem_page.dart';
import 'package:gdsc_bloc/View/Profile/Help/send_feedback_page.dart';
import 'package:gdsc_bloc/View/Resources/more_resources_page.dart';
import 'package:gdsc_bloc/View/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final resourceArgs = settings.arguments;

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
      case '/personal_information':
        return MaterialPageRoute(builder: (_) => PersonalInformation());
      case '/community_leads':
        return MaterialPageRoute(builder: (_) => const CommunityLeads());
      case '/user_resources':
        return MaterialPageRoute(builder: (_) => UserResources());
      case '/send_feedback':
        return MaterialPageRoute(builder: (_) => SendFeedbackPage());
      case '/report_problem':
        return MaterialPageRoute(builder: (_) => ReportProblemPage());
      case '/contact_developer':
        return MaterialPageRoute(builder: (_) => const ContactDeveloperPage());
      case '/about_app':
        return MaterialPageRoute(builder: (_) => const AboutPage());
      case '/announcement_page':
        return MaterialPageRoute(builder: (_) => AnnouncementPage());
      case '/post_resource':
        return MaterialPageRoute(builder: (_) => ResourcePostPage());
      case '/more_resource':
        if (resourceArgs is ResourceArguments) {
          return MaterialPageRoute(
            builder: (_) => MoreResourcesPage(
              title: resourceArgs.title,
              category: resourceArgs.category,
            ),
          );
        } else {
          return _errorRoute();
        }
      case '/image_view':
        if (resourceArgs is ImageArguments) {
          return MaterialPageRoute(
            builder: (_) => ImageView(
              title: resourceArgs.title,
              image: resourceArgs.image,
            ),
          );
        } else {
          return _errorRoute();
        }
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

class ResourceArguments {
  final String title;
  final String category;

  ResourceArguments({required this.title, required this.category});
}

class ImageArguments {
  final String title;
  final String image;

  ImageArguments({required this.title, required this.image});
}
