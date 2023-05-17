import 'package:flutter/material.dart';
import 'package:gdsc_bloc/View/Authentication/forgot_password_page.dart';
import 'package:gdsc_bloc/View/Authentication/login_page.dart';
import 'package:gdsc_bloc/View/Authentication/register_page.dart';
import 'package:gdsc_bloc/View/Authentication/reset_password_page.dart';
import 'package:gdsc_bloc/View/Home/profile_page.dart';
import 'package:gdsc_bloc/View/home.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/login':
        return MaterialPageRoute(builder: (_) =>  LoginPage());
         case '/register':
        return MaterialPageRoute(builder: (_) =>  RegisterPage());
         case '/forgot_password':
        return MaterialPageRoute(builder: (_) =>  ForgotPassword());
        case '/reset_password':
        return MaterialPageRoute(builder: (_) =>  ResetPassword());
        case '/profile':
        return MaterialPageRoute(builder: (_) =>  const ProfilePage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black54),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }
}
