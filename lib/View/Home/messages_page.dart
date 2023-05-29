// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_bloc/Blocs/AppFuntions/app_functions_cubit.dart';
import 'package:gdsc_bloc/Data/Models/message_model.dart';
import 'package:gdsc_bloc/Data/Repository/providers.dart';
import 'package:gdsc_bloc/Data/Repository/repository.dart';
import 'package:gdsc_bloc/Util/Widgets/chat_bubble.dart';
import 'package:gdsc_bloc/Util/image_urls.dart';
import 'package:gdsc_bloc/Util/route_generator.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesPage extends StatefulWidget {
  MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final messageController = TextEditingController();
  final focusNode = FocusNode();
  String? image;

  @override
  void initState() {
    super.initState();
    messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).viewInsets.bottom;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.background),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10, left: 10, top: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    focusNode: focusNode,
                    keyboardType: TextInputType.multiline,
                    maxLines: 15,
                    minLines: 1,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: const Color(0xffFFFFFF),
                    ),
                    
                    decoration: InputDecoration(
                      fillColor: Colors.blueGrey[900]!,
                      contentPadding: EdgeInsets.only(left: 10),
                      filled: true,
                      suffixIcon: BlocProvider(
                        create: (context) => AppFunctionsCubit(),
                        child: Builder(builder: (context) {
                          return BlocConsumer<AppFunctionsCubit,
                              AppFunctionsState>(
                            listener: (context, state) {
                              if (state is ImagePicked) {
                                image = state.imageUrl;
                              }
                            },
                            builder: (context, state) {
                              return IconButton(
                                onPressed: () {
                                  BlocProvider.of<AppFunctionsCubit>(context)
                                      .getImage();
                                },
                                icon:Icon(Icons.attach_file,
                                  color: Colors.white,
                                  size: 18,)
                              );
                            },
                          );
                        }),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Colors.grey[500]!, width: 0.4),
                      ),
                      
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color:Color(0xff204F46),
                        
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      if (messageController.text.isNotEmpty) {
                        Providers().sendMessage(
                            message: messageController.text,
                            image: image ?? "null");
                        messageController.clear();
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Community Page",
            style: GoogleFonts.quicksand(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: StreamBuilder<List<Message>>(
          stream: Repository().getMessages(),
          builder: (context, snapshot) {
            Widget out = const SizedBox.shrink();
            if (snapshot.connectionState == ConnectionState.waiting) {
              out = Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              out = ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final event = snapshot.data![index];
                  final timestamp = DateTime.fromMicrosecondsSinceEpoch(
                      event.timestamp.microsecondsSinceEpoch);
                  return BubbleSpecialOne(
                    // seen: true,
                    text: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        event.id == FirebaseAuth.instance.currentUser!.uid
                            ? Container(
                                height: 3,
                              )
                            : Text(
                                event.name,
                                style: GoogleFonts.quicksand(
                                  fontSize: 12,
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        Text(
                          event.message,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                        event.image == "null"
                                ? SizedBox.shrink()
                                :Column(
                          children: [
                            const SizedBox(
                          height: 8,
                        ),
                             Semantics(
                                    button: true,
                                    child: InkWell(
                                      onTap: () {
                                        focusNode.unfocus();
                                        Navigator.pushNamed(context, '/image_view',
                                            arguments: ImageArguments(
                                                title: "Image view",
                                                image: event.image));
                                      },
                                      child: CachedNetworkImage(
                                        height:
                                            MediaQuery.of(context).size.height * .2,
                                        width: MediaQuery.of(context).size.width * .7,
                                        placeholder: (context, url) {
                                          return Container(
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    .2,
                                            width: MediaQuery.of(context).size.width *
                                                .7,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 243, 243, 243),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          );
                                        },
                                        errorWidget: ((context, url, error) {
                                          return const Icon(
                                            Icons.error,
                                            size: 20,
                                            color: Colors.red,
                                          );
                                        }),
                                        imageUrl: event.image,
                                        fit: BoxFit.fitHeight,
                                        imageBuilder: (context, imageProvider) {
                                          return AnimatedContainer(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(
                                                  width: 0.4,
                                                  color: const Color(0xff666666)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            duration:
                                                const Duration(milliseconds: 500),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                   const SizedBox(
                          height: 8,
                        ),
                          ],
                        ),
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              //get time in pm or am after converting from 12 hour format
                              "${timestamp.hour}:${timestamp.minute} ${timestamp.hour >= 12 ? "PM" : "AM"}",
    
                              style: GoogleFonts.quicksand(
                                fontSize: 9,
                                color: Color.fromARGB(255, 208, 207, 207),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    isSender: event.id == FirebaseAuth.instance.currentUser!.uid
                        ? true
                        : false,
                    color: event.id == FirebaseAuth.instance.currentUser!.uid
                        ? Color(0xff204F46)
                        : Colors.blueGrey[900]!,
                    textStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              );
            }
            return out;
          },
        ),
      ),
    );
  }
}
