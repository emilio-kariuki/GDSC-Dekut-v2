import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/AppFuntions/app_functions_cubit.dart';

import 'package:gdsc_bloc/Util/Widgets/category_widget.dart';
import 'package:gdsc_bloc/Util/Widgets/resource_category.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:google_fonts/google_fonts.dart';

class ResourcesPage extends StatelessWidget {
   ResourcesPage({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppFunctionsCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xff666666),
              elevation: 2,
              onPressed: () {},
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.white,
            body:  AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.white,
          ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: RefreshIndicator(
                    onRefresh: () async {
                     
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Your Resources",
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: const Color(0xff000000),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 49,
                            padding: const EdgeInsets.only(left: 15, right: 1),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.grey[500]!,
                                  width: 0.8,
                                )),
                            child: TextFormField(
                              controller: searchController,
                              // onFieldSubmitted: (value) {
                              //   context
                              //       .read<AppFunctionsCubit>()
                              //       .searchResource(query: value);
                              // },
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: const Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                hintText: "Search for resource eg. Flutter",
                                border: InputBorder.none,
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xff666666),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CategoryWidget(
                                title: "Mobile Development",
                                location: "/",
                              ),
                              ResourceCategory(
                                height: height,
                                width: width,
                                category: "mobile",
                                image: AppImages.eventImage,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CategoryWidget(
                                title: "Data Science",
                                location: "/d",
                              ),
                              ResourceCategory(
                                height: height,
                                width: width,
                                category: "data",
                                image: AppImages.eventImage,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CategoryWidget(
                                title: "Design Development",
                                location: "/d",
                              ),
                              ResourceCategory(
                                height: height,
                                width: width,
                                category: "design",
                                image: AppImages.eventImage,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CategoryWidget(
                                title: "Web Development",
                                location: "/d",
                              ),
                              ResourceCategory(
                                height: height,
                                width: width,
                                category: "design",
                                image: AppImages.eventImage,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CategoryWidget(
                                title: "Cloud Development",
                                location: "/d",
                              ),
                              ResourceCategory(
                                height: height,
                                width: width,
                                category: "design",
                                image: AppImages.eventImage,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CategoryWidget(
                                title: "Internet of Things (IoT)",
                                location: "/d",
                              ),
                              ResourceCategory(
                                height: height,
                                width: width,
                                category: "design",
                                image: AppImages.eventImage,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CategoryWidget(
                                title: "Artificial Intelligence",
                                location: "/d",
                              ),
                              ResourceCategory(
                                height: height,
                                width: width,
                                category: "dassfasdfasf",
                                image: AppImages.eventImage,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CategoryWidget(
                                title: "Game Development",
                                location: "/d",
                              ),
                              ResourceCategory(
                                height: height,
                                width: width,
                                category: "design",
                                image: AppImages.eventImage,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
