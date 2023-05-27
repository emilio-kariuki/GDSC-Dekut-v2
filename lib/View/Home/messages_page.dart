// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_bloc/Data/Models/message_model.dart';
import 'package:gdsc_bloc/Data/Repository/repository.dart';
import 'package:gdsc_bloc/Util/Widgets/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesPage extends StatelessWidget {
  MessagesPage({super.key});
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10, left: 10, top: 10),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: messageController,
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                minLines: 1,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: const Color(0xff000000),
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide:
                        BorderSide(color: Colors.grey[500]!, width: 0.4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
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
            IconButton(
              onPressed: () async {
                if (messageController.text.isNotEmpty) {
                  Repository().sendMessage(
                    message: messageController.text,
                  );
                  messageController.clear();
                }
              },
              icon: const Icon(Icons.send, color: Colors.black),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Messages Page"),
      ),
      body: StreamBuilder<List<Message>>(
        stream: Repository().getMessages(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final event = snapshot.data![index];
              final timestamp = DateTime.fromMicrosecondsSinceEpoch(
                  event.timestamp!.microsecondsSinceEpoch);
              return BubbleSpecialOne(
                seen: true,
                text: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    event.id == FirebaseAuth.instance.currentUser!.uid
                        ? Container(
                            height: 3,
                          )
                        : Text(
                            event.name!,
                            style: GoogleFonts.quicksand(
                              fontSize: 12,
                              color: Colors.red[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    Text(
                      event.message!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
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
                    ? Colors.teal[900]!
                    : Colors.blueGrey[800]!,
                textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
