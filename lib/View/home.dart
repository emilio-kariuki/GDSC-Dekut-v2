import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_bloc/Blocs/AppFuntions/app_functions_cubit.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:gdsc_bloc/View/Home/home_page.dart';
import 'package:gdsc_bloc/View/Home/messages_page.dart';
import 'package:gdsc_bloc/View/Home/profile_page.dart';
import 'package:gdsc_bloc/View/Home/resources_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget getBody() {
    List<Widget> pages = [
      EventPage(),
      ResourcesPage(),
      MessagesPage(),
      const ProfilePage(),
    ];
    return BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
      builder: (context, state) {
        return IndexedStack(
          index: state is TabChanged ? state.index : 0,
          children: pages,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppFunctionsCubit(),
      child: Scaffold(
          backgroundColor: const Color(0xffF6F6F6),
          extendBody: false,
          body: getBody(),
          bottomNavigationBar: getFooter()),
    );
  }

  Widget getFooter() {
    final List<Map<String, dynamic>> items = [
      {
        "one": AppImages.home_white,
        "two": AppImages.home_black,
      },
      {
        "one": AppImages.resources_white,
        "two": AppImages.resources_black,
      },
      {
        "one": AppImages.messages_white,
        "two": AppImages.messages,
      },
      {
        "one": AppImages.person_white,
        "two": AppImages.person_black,
      },
    ];
    return Builder(builder: (context) {
      return BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
        builder: (context, state) {
          return AnimatedBottomNavigationBar.builder(
            elevation: 0,
            backgroundColor: Colors.white,
            notchSmoothness: NotchSmoothness.softEdge,
            itemCount: items.length,
            activeIndex: state is TabChanged ? state.index : 0,
            gapWidth: 10,
            onTap: (index) {
              BlocProvider.of<AppFunctionsCubit>(context)
                  .changeTab(index: index);
                  SystemChannels.textInput.invokeMethod('TextInput.hide');

            },
            tabBuilder: (int index, bool isActive) {
              final icons = items[index];
              return Padding(
                  padding: index == 2
                      ? const EdgeInsets.all(20.0)
                      : index == 3
                          ? const EdgeInsets.all(20.0)
                          : const EdgeInsets.all(18.0),
                  child: SvgPicture.asset(
                    isActive ? icons['two'] : icons['one'],
                    height: MediaQuery.of(context).size.height * 0.03,
                  ));
            },
          );
        },
      );
    });
  }
}
