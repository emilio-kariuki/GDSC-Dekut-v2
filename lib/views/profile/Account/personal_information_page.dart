// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Blocs/app_functions_cubit/app_functions_cubit.dart';
import 'package:gdsc_bloc/utilities/Widgets/input_field.dart';
import 'package:gdsc_bloc/utilities/Widgets/loading_circle.dart';
import 'package:gdsc_bloc/utilities/image_urls.dart';
import 'package:gdsc_bloc/utilities/shared_preference_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInformation extends StatelessWidget {
  PersonalInformation({super.key});

  final imagePicker = ImagePicker();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final githubController = TextEditingController();

  final twitterController = TextEditingController();

  final linkedinController = TextEditingController();

  final technologyController = TextEditingController();

  String image = AppImages.defaultImage;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => AppFunctionsCubit()..fetchUser(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Color(0xff666666), size: 20),
            title: Text(
              "Personal Information",
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: const Color(0xff666666),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocListener<AppFunctionsCubit, AppFunctionsState>(
              listener: (context, state) {
                if (state is UserFetched) {
                  nameController.text = state.user.name!;
                  emailController.text = state.user.email!;
                  phoneController.text = state.user.phone!;
                  githubController.text = state.user.github!;
                  twitterController.text = state.user.twitter!;
                  linkedinController.text = state.user.linkedin!;
                  technologyController.text = state.user.technology!;
                  image = state.user.imageUrl!;
                }
                if (state is UpdateUserSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content: const Text("updated information successfully")));
                }

                if (state is UpdateUserFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content: Text(state.message)));
                }
              },
              child: BlocBuilder<AppFunctionsCubit, AppFunctionsState>(
                builder: (context, state) {
                  return state is UpdateUserLoading
                      ? const LoadingCircle()
                      : SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final userId =
                                  await SharedPreferencesManager().getId();
                              context.read<AppFunctionsCubit>().updateUser(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text,
                                    github: githubController.text,
                                    linkedin: linkedinController.text,
                                    twitter: twitterController.text,
                                    userId: userId,
                                    technology: technologyController.text,
                                    image: image,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff000000),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              "Save Data",
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
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<AppFunctionsCubit>().fetchUser();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              height: height * 0.13,
                              width: height * 0.13,
                              decoration: const BoxDecoration(
                                color: Color(0xffF6F6F6),
                                shape: BoxShape.circle,
                              ),
                              child: BlocBuilder<AppFunctionsCubit,
                                  AppFunctionsState>(
                                builder: (context, state) {
                                  if (state is ImagePicked) {
                                    image = state.imageUrl;
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(
                                        state.image,
                                        fit: BoxFit.fitHeight,
                                        height: height * 0.13,
                                        width: height * 0.13,
                                      ),
                                    );
                                  } else {
                                    return Center(
                                        child: CachedNetworkImage(
                                      imageUrl: image,
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          height: height * 0.13,
                                          width: height * 0.13,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF6F6F6),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.grey[500]!,
                                              width: 0.7,
                                            ),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ));
                                  }
                                  return const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned.fill(
                                child: Align(
                              alignment: Alignment.bottomRight,
                              child: Semantics(
                                button: true,
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<AppFunctionsCubit>()
                                        .getImage();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.photo_camera_outlined,
                                        color: Colors.white,
                                        size: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputField(
                        title: "Name",
                        controller: nameController,
                        hintText: "Enter your name",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InputField(
                        title: "Email",
                        controller: emailController,
                        hintText: "Enter your email",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InputField(
                        title: "Phone",
                        controller: phoneController,
                        hintText: "Enter your phone",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InputField(
                        title: "Github",
                        controller: githubController,
                        hintText: "Enter your github username",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InputField(
                        title: "Twitter",
                        controller: twitterController,
                        hintText: "Enter your twitter username",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InputField(
                        title: "Technology",
                        controller: technologyController,
                        hintText: "Enter your technology",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InputField(
                        title: "Linkedin",
                        controller: linkedinController,
                        hintText: "Enter your linkedin  name",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
