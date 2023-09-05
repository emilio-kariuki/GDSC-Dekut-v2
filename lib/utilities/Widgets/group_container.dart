// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/data/Services/Providers/providers.dart';
import 'package:gdsc_bloc/utilities/route_generator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Blocs/app_functions_cubit/app_functions_cubit.dart';

void _showImageDialog(
    {required BuildContext context,
    required String image,
    required String title,
    required double height,
    required String link,
    required double width}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Scaffold(
                bottomNavigationBar: Container(
                    height: height * 0.11,
                    width: width,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(
                        width: 0.4,
                      )),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BlocProvider(
                          create: (context) => AppFunctionsCubit(),
                          child: Builder(builder: (context) {
                            return BlocBuilder<AppFunctionsCubit,
                                AppFunctionsState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 5),
                                      // padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          // color: Colors.grey[800],
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                        onPressed: () {
                                          BlocProvider.of<AppFunctionsCubit>(
                                                  context)
                                              .copyToClipboard(text: link);
                                        },
                                        icon: Icon(
                                          state is Copied
                                              ? Icons.check
                                              : Icons.link,
                                          size: 22,
                                          // // color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      state is Copied ? "Copied" : "Copy",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        // // color: Colors.white,
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 5),
                              // padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  // // color: Colors.grey[800],
                                  shape: BoxShape.circle),
                              child: IconButton(
                                onPressed: () {
                                  Providers().openLink(link: link);
                                },
                                icon: const Icon(
                                  Icons.join_full,
                                  size: 22,
                                  // // color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              "Join",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                // // color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        BlocProvider(
                          create: (context) => AppFunctionsCubit(),
                          child: Builder(builder: (context) {
                            return BlocBuilder<AppFunctionsCubit,
                                AppFunctionsState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 5),
                                      // padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          // // color: Colors.grey[800],
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                        onPressed: () async {
                                          await Permission.storage.request();
                                          BlocProvider.of<AppFunctionsCubit>(
                                                  context)
                                              .downloadAndSaveImage(
                                                  image: image,
                                                  fileName: title);
                                        },
                                        icon: state is Saving
                                            ? const Center(
                                                child: SizedBox(
                                                  height: 15,
                                                  width: 15,
                                                  child:
                                                      CircularProgressIndicator(
                                                    // // color: Colors.white,
                                                    strokeWidth: 3,
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                state is Saved
                                                    ? Icons.check
                                                    : Icons.save_alt,
                                                size: 22,
                                                // // color: Colors.white,
                                              ),
                                      ),
                                    ),
                                    Text(
                                      state is Saved ? "Saved" : "Save",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        // // color: Colors.white,
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 5),
                              // padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  // // color: Colors.grey[800],
                                  shape: BoxShape.circle),
                              child: IconButton(
                                onPressed: () {
                                  Providers().share(
                                      message:
                                          "The link to join $title is $image");
                                },
                                icon: const Icon(
                                  Icons.share,
                                  size: 22,
                                  // // color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              "Share",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                // // color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: AppBar(
                    // // backgroundColor: Colors.grey[900],
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: Text(
                      title,
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        // // color: Colors.white,
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 20,
                            // // color: Colors.white,
                          ))
                    ],
                  ),
                ),
                body: Semantics(
                  button: true,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/image_view',
                          arguments:
                              ImageArguments(title: title, image: image));
                    },
                    child: CachedNetworkImage(
                      height: height * 0.3,
                      width: width,
                      placeholder: (context, url) {
                        return Container(
                          height: height * 0.3,
                          width: width,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 243, 243, 243),
                          
                          border: Border.all(
                            width: 0.4,
                            color: Color(0xff666666),
                          ),
                          
                        ));
                      },
                      errorWidget: ((context, url, error) {
                        return const Icon(
                          Icons.error,
                          size: 20,
                          // // color: Colors.red,
                        );
                      }),
                      imageUrl: image,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) {
                        return AnimatedContainer(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.4,
                              // // color: const Color(0xff666666),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                    ),
                  ),
                ),
              )),
        ),
      );
    },
  );
}

class GroupContainer extends StatelessWidget {
  const GroupContainer({
    super.key,
    required this.height,
    required this.width,
    required this.image,
    required this.title,
    required this.link,
  });

  final double height;
  final double width;
  final String image;
  final String title;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            _showImageDialog(
              context: context,
              image: image,
              title: title,
              height: height,
              width: width,
              link: link,
            );
          },
          child: CachedNetworkImage(
            height: height * 0.12,
            width: width * 0.32,
            placeholder: (context, url) {
              return Container(
                height: height * 0.12,
                width: width * 0.32,
                decoration: BoxDecoration(
                    // // color: const Color.fromARGB(255, 243, 243, 243),
                    borderRadius: BorderRadius.circular(10)),
              );
            },
            errorWidget: ((context, url, error) {
              return const Icon(
                Icons.error,
                size: 20,
                // // color: Colors.red,
              );
            }),
            imageUrl: image,
            fit: BoxFit.fitHeight,
            imageBuilder: (context, imageProvider) {
              return AnimatedContainer(
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 0.4,
                    // // color: const Color(0xff666666),
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                duration: const Duration(milliseconds: 500),
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        Center(
          child: SizedBox(
            width: width * 0.27,
            child: Text(
              title,
              overflow: TextOverflow.clip,
              maxLines: 2,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                // // color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
