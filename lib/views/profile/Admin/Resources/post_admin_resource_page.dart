// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/app_functions_cubit/app_functions_cubit.dart';

import 'package:gdsc_bloc/utilities/Widgets/input_field.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminResourcePostPage extends StatelessWidget {
  AdminResourcePostPage({super.key, required this.tabController});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String image = "";
  final linkController = TextEditingController();
  String? selectedType;
  final TabController tabController;

  final List<String> items = [
    "mobile",
    "data",
    "design",
    "web",
    "cloud",
    "iot",
    "ai",
    "game",
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => AppFunctionsCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocListener<AppFunctionsCubit, AppFunctionsState>(
              listener: (context, state) {
                if (state is ResourceSent) {
                  Timer(
                    const Duration(milliseconds: 300),
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF0C7319),
                        content: Text("Resource Sent Successfully"),
                      ),
                    ),
                  );

                                    tabController.animateTo(0);

                }

                if (state is ResourceSendingFailed) {
                  Timer(
                    const Duration(milliseconds: 300),
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFFD5393B),
                        content: Text(state.message),
                      ),
                    ),
                  );
                }
              },
              child: BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                builder: (context, state) {
                  return state is ResourceSending
                      ? const LoadingCircle()
                      : SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<AppFunctionsCubit>(context)
                                  .createAdminResource(
                                title: titleController.text,
                                description: descriptionController.text,
                                link: linkController.text,
                                category: selectedType!,
                                imageUrl: image,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              "Post",
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
            ),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                        title: "Title",
                        controller: titleController,
                        hintText: "Enter the title of the resource"),
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
                        title: "Description",
                        controller: descriptionController,
                        hintText: "Enter the description of the resource"),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Resource Type",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff000000),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocConsumer<AppFunctionsCubit, AppFunctionsState>(
                      listener: (context, state) {
                        if (state is DropDownChanged) {
                          selectedType = state.value;
                        }
                      },
                      builder: (context, state) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Text(
                              'Select a resource type',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: items
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: state is DropDownChanged
                                ? state.value
                                : selectedType,
                            onChanged: (value) {
                              BlocProvider.of<AppFunctionsCubit>(context)
                                  .dropDownClicked(value: value.toString());
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: width,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.grey[500]!,
                                ),
                                color: Colors.transparent,
                              ),
                              elevation: 0,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: width * 0.9,
                              padding: null,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              elevation: 0,
                              offset: const Offset(0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility:
                                    MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InputField(
                        title: "Resource Link",
                        controller: linkController,
                        hintText: "Enter the link to the resource"),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                      builder: (context, state) {
                        return BlocListener<AppFunctionsCubit,
                            AppFunctionsState>(
                          listener: (context, state) {
                            if (state is ImagePicked) {
                              image = state.imageUrl;
                              Timer(
                                const Duration(milliseconds: 300),
                                () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Color(0xFF0C7319),
                                    content: Text("Image uploaded"),
                                  ),
                                ),
                              );
                            }

                            if (state is ImagePickingFailed) {
                              Timer(
                                const Duration(milliseconds: 100),
                                () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: const Color(0xFFD5393B),
                                    content: Text(state.message),
                                  ),
                                ),
                              );
                            }
                          },
                          child:
                              BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                            builder: (context, state) {
                              return state is ImageUploading
                                  ? const LoadingCircle()
                                  : SizedBox(
                                      height: 50,
                                      width: 120,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          BlocProvider.of<AppFunctionsCubit>(
                                                  context)
                                              .getImage();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff000000),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: Text(
                                          "Add Image",
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        );
                      },
                    )
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
