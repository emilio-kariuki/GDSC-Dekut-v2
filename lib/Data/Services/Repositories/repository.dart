// ignore_for_file: unnecessary_null_comparison, avoid_print, deprecated_member_use, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gdsc_bloc/data/Models/announcement_model.dart';
import 'package:gdsc_bloc/data/Models/developer_model.dart';
import 'package:gdsc_bloc/data/Models/event_model.dart';
import 'package:gdsc_bloc/data/Models/feedback_model.dart';
import 'package:gdsc_bloc/data/Models/groups_model.dart';
import 'package:gdsc_bloc/data/Models/leads_model.dart';
import 'package:gdsc_bloc/data/Models/message_model.dart';
import 'package:gdsc_bloc/data/Models/report_model.dart';
import 'package:gdsc_bloc/data/Models/resource_model.dart';
import 'package:gdsc_bloc/data/Models/twitter_model.dart';
import 'package:gdsc_bloc/data/Models/user_model.dart';
import 'package:gdsc_bloc/utilities/shared_preference_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:uuid/uuid.dart" as uuid;
import 'package:share_plus/share_plus.dart';

class Repository {
  

  
// ! NOT IMPORTANT FOR NOW
  // Future<bool> changeEmail(
  //     {required String email,
  //     required String password,
  //     required String newEmail}) async {
  //   final auth = FirebaseAuth.instance;
  //   try {
  //     User user = auth.currentUser!;
  //     final credential =
  //         EmailAuthProvider.credential(email: email, password: password);
  //     await user.reauthenticateWithCredential(credential);
  //     await user.updateEmail(newEmail);
  //     debugPrint("Change Email Succesfull");
  //     return true;
  //   } on FirebaseException catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  

  

  Stream<List<EventModel>> getEvents() async* {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final events = firebaseFirestore.collection("event").snapshots().map(
          (event) =>
              event.docs.map((e) => EventModel.fromJson(e.data())).toList());

      yield* events;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future sendMessage({
    required String message,
    required String image,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection("messages").add({
        "message": message,
        "name": await SharedPreferencesManager().getName(),
        "id": await SharedPreferencesManager().getId(),
        "time": DateTime.now().millisecondsSinceEpoch,
        "image": image,
        "timestamp": DateTime.now().toString(),
      });
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> deleteMessage({required int time}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("messages")
          .where("time", isEqualTo: time)
          .get()
          .then((value) => value.docs.first.reference.delete());

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Stream<List<Message>> getMessages() async* {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final messages = firebaseFirestore
          .collection("messages")
          .orderBy("time", descending: false)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Message.fromJson(e.data())).toList());

      yield* messages;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> getResources({required String category}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resource")
          .where(
            "category",
            isEqualTo: category,
          )
          .where("isApproved", isEqualTo: true)
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());
      return resources;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> getUnApprovedResources() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resource")
          .where("isApproved", isEqualTo: false)
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());
      return resources;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> getAllResources() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resource")
          .where("isApproved", isEqualTo: true)
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());
      return resources;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> getUserResources({required String userId}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resource")
          .where("userId", isEqualTo: userId)
          .where("isApproved", isEqualTo: true)
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());
      return resources;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> getResource() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resources")
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());
      return resources;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<EventModel>> getEvent() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final event = await firebaseFirestore
          .collection("event")
          .where("isCompleted", isEqualTo: false)
          .get()
          .then((value) =>
              value.docs.map((e) => EventModel.fromJson(e.data())).toList());
      return event;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<EventModel>> getPastEvent() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final event = await firebaseFirestore
          .collection("event")
          .where("isCompleted", isEqualTo: true)
          .get()
          .then((value) =>
              value.docs.map((e) => EventModel.fromJson(e.data())).toList());
      return event;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> searchResources({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resource")
          .where("isApproved", isEqualTo: true)
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());

      return resources
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<AnnouncementModel>> searchAnnouncement(
      {required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final announcement = await firebaseFirestore
          .collection("announcement")
          .get()
          .then((value) => value.docs
              .map((e) => AnnouncementModel.fromJson(e.data()))
              .toList());

      return announcement
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> searchUnApprovedResources(
      {required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resource")
          .where("isApproved", isEqualTo: false)
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());

      return resources
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> searchCategoryResources(
      {required String query, required String category}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resource")
          .where("isApproved", isEqualTo: true)
          .where("category", isEqualTo: category)
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());

      return resources
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Resource>> searchUserResources(
      {required String query, required String userId}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final resources = await firebaseFirestore
          .collection("resource")
          .where("userId", isEqualTo: userId)
          .where("isApproved", isEqualTo: true)
          .get()
          .then((value) =>
              value.docs.map((e) => Resource.fromJson(e.data())).toList());

      return resources
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> deleteResource({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("resource")
          .doc(id)
          .get()
          .then((value) => value.reference.delete());

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> deleteEvent({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("event")
          .doc(id)
          .get()
          .then((value) => value.reference.delete());

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<EventModel>> searchEvent({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final events = await firebaseFirestore
          .collection("event")
          .where("isCompleted", isEqualTo: false)
          .get()
          .then((value) =>
              value.docs.map((e) => EventModel.fromJson(e.data())).toList());

      return events
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<EventModel>> searchPastEvent({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final events = await firebaseFirestore
          .collection("event")
          .where("isCompleted", isEqualTo: true)
          .get()
          .then((value) =>
              value.docs.map((e) => EventModel.fromJson(e.data())).toList());

      return events
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<EventModel> getParticularEvent({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final event = await firebaseFirestore.collection("event").doc(id).get();

      return EventModel.fromJson(event.data()!);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final announcement = await firebaseFirestore
          .collection("announcement")
          .get()
          .then((value) => value.docs
              .map((e) => AnnouncementModel.fromJson(e.data()))
              .toList());

      return announcement;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<AnnouncementModel> getParticularAnnouncement(
      {required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final announcement =
          await firebaseFirestore.collection("announcement").doc(id).get();

      return AnnouncementModel.fromJson(announcement.data()!);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> deleteParticularAnnouncement({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("announcement")
          .doc(id)
          .get()
          .then((value) => value.reference.delete());

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> updateParticularAnnouncement(
      {required String id,
      required String name,
      required String position,
      required String title}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection("announcement").doc(id).update({
        "id": id,
        "name": name,
        "position": position,
        "title": title,
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> createAnnouncement(
      {required String name,
      required String position,
      required String title}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final id = const uuid.Uuid().v1(options: {
        'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
        'clockSeq': 0x1234,
        'mSecs': DateTime.now().millisecondsSinceEpoch,
        'nSecs': 5678
      }); //

      await firebaseFirestore.collection("announcement").doc(id).set({
        "id": id,
        "name": name,
        "position": position,
        "title": title,
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> finishParticularEvent({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("event")
          .doc(id)
          .update({"isCompleted": true});

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<Resource> getParticularResource({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final event =
          await firebaseFirestore.collection("resource").doc(id.trim()).get();

      return Resource.fromJson(event.data()!);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> approveResource({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("resource")
          .doc(id)
          .update({"isApproved": true});

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> startParticularEvent({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("event")
          .doc(id)
          .update({"isCompleted": false});

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> createLead({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String github,
    required String twitter,
    required String bio,
    required String image,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection("lead").doc().set({
        "name": name,
        "email": email,
        "phone": phone,
        "role": role,
        "github": github,
        "twitter": twitter,
        "bio": bio,
        "image": image,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> updateLead({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String github,
    required String twitter,
    required String bio,
    required String image,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection("lead").doc().update(
        {
          "name": name,
          "email": email,
          "phone": phone,
          "role": role,
          "github": github,
          "twitter": twitter,
          "bio": bio,
          "image": image,
        },
      );
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> deleteLead({required String email}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("lead")
          .where("email", isEqualTo: email)
          .get()
          .then((value) => value.docs.first.reference.delete());

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<LeadsModel> getLead({required String email}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final lead = await firebaseFirestore
          .collection("lead")
          .where("email", isEqualTo: email)
          .get()
          .then((value) => value.docs.first.data());

      return LeadsModel.fromJson(lead);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<FeedbackModel>> getFeedback() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final feedback = await firebaseFirestore
          .collection("feedback")
          .get()
          .then((value) =>
              value.docs.map((e) => FeedbackModel.fromJson(e.data())).toList());

      return feedback;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<ReportModel>> getReports() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final problem = await firebaseFirestore.collection("problem").get().then(
          (value) =>
              value.docs.map((e) => ReportModel.fromJson(e.data())).toList());

      return problem;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> createEvent({
    required String title,
    required String venue,
    required String organizers,
    required String link,
    required String imageUrl,
    required String description,
    required String startTime,
    required String endTime,
    required Timestamp date,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final id = const uuid.Uuid().v1(options: {
        'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
        'clockSeq': 0x1234,
        'mSecs': DateTime.now().millisecondsSinceEpoch,
        'nSecs': 5678
      }); //

      await firebaseFirestore.collection("event").doc(id).set({
        "id": id,
        "title": title,
        "venue": venue,
        "organizers": organizers,
        "link": link,
        "imageUrl": imageUrl,
        "isCompleted": false,
        "description": description,
        "startTime": startTime,
        "endTime": endTime,
        "date": date,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> createGroup({
    required String title,
    required String description,
    required String imageUrl,
    required String link,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final id = const uuid.Uuid().v1(options: {
        'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
        'clockSeq': 0x1234,
        'mSecs': DateTime.now().millisecondsSinceEpoch,
        'nSecs': 5678
      }); //

      await firebaseFirestore.collection("announcements").doc(id).set({
        "id": id,
        "title": title,
        "link": link,
        "imageUrl": imageUrl,
        "description": description,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> updateGroup({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required String link,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection("announcements").doc(id).update(
        {
          "id": id,
          "title": title,
          "link": link,
          "imageUrl": imageUrl,
          "description": description,
        },
      );
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> createSpace({
    required String title,
    required String link,
    required Timestamp startTime,
    required Timestamp endTime,
    required String image,
    required Timestamp date,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final id = const uuid.Uuid().v1(options: {
        'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
        'clockSeq': 0x1234,
        'mSecs': DateTime.now().millisecondsSinceEpoch,
        'nSecs': 5678
      }); //

      await firebaseFirestore.collection("twitter").doc(id).set({
        "id": id,
        "title": title,
        "link": link,
        "image": image,
        "startTime": startTime,
        "endTime": endTime,
        "date": date,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> updateSpace({
    required String id,
    required String title,
    required String link,
    required Timestamp startTime,
    required Timestamp endTime,
    required String image,
    required Timestamp date,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection("twitter").doc(id).update(
        {
          "id": id,
          "title": title,
          "link": link,
          "image": image,
          "startTime": startTime,
          "endTime": endTime,
          "date": date,
        },
      );
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> updateEvent({
    required String id,
    required String title,
    required String venue,
    required String organizers,
    required String link,
    required String imageUrl,
    required String description,
    required String startTime,
    required String endTime,
    required Timestamp date,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection("event").doc(id).update({
        "id": id,
        "title": title,
        "venue": venue,
        "organizers": organizers,
        "link": link,
        "imageUrl": imageUrl,
        "isCompleted": false,
        "description": description,
        "startTime": startTime,
        "endTime": endTime,
        "date": date,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> addEventToCalendar({
    required String title,
    required String summary,
    required Timestamp startTime,
    required Timestamp endTime,
  }) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
      'email',
      // 'https://www.googleapis.com/auth/calendar',
      // 'https://www.googleapis.com/auth/calendar.events'
    ]);

    await googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleSignIn.currentUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final AuthClient authClient = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken(
          'Bearer',
          credential.accessToken!,
          DateTime.now().toUtc().add(
                const Duration(seconds: 10),
              ),
        ),
        credential.idToken,
        ['https://www.googleapis.com/auth/calendar'],
      ),
    );
    final calendar.CalendarApi calendarApi = calendar.CalendarApi(authClient);

    calendar.Event event = calendar.Event();

    event.summary = title;
    event.description = summary;

    calendar.EventDateTime start = calendar.EventDateTime();
    start.dateTime = startTime.toDate();
    start.timeZone = "GMT+03:00";
    event.start = start;

    calendar.EventDateTime end = calendar.EventDateTime();
    end.dateTime = endTime.toDate().add(const Duration(hours: 1));
    end.timeZone = "GMT+03:00";
    event.end = end;

    try {
      await calendarApi.events.insert(event, 'primary');
      print('Event added to the calendar');
      return true;
    } catch (e) {
      print('Error creating calendar event: $e');
      return false;
    }

    // try {

    //   ////////////////////////////////////
    //   print("Called");
    //   final scopes = [
    //     calendar.CalendarApi.calendarScope,
    //     calendar.CalendarApi.calendarEventsScope,
    //     calendar.CalendarApi.calendarEventsReadonlyScope,
    //   ];

    //   var credentials = ServiceAccountCredentials.fromJson({
    //     'private_key':
    //         '-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCuJFvmMykM1KT9\nHC4lWFgkk4AGdNb87jeel/tCubJe7sN7MasYXYbgMAcrRBDUomX5NCaI4ZWIm3xX\nLgmje8gchTyK6/cfWHhdwYM1I39H6+Ykg2IaDhrIM8NW/yITPh0Oz/6V5EUsl6ic\n4oLOsoTxrHVmaHLul2QNRLPkXlMVD1DKJT/SnVEgWzcsOkEKRqPXIsaHwWaujTqy\nneqHDevzCs5aTJxZkSN6gMZC7Us2H6AMR343HKWPzI/5SmmTAzfCPyxyrtH2JqQB\nyEfvJ706y1QOcLV1c/BzpoqYRY80pkaMu4EfZSQT7Uic8Ms/ah7inl5g/YzGhZCc\nQ3XzyYp3AgMBAAECggEAB687DvF7AkHv9etkbel0GkkYATDuu8KXWbxDLjKbmGzY\n23rZnf2ikgoMhvA9/eQcs96FRM0PmDOkTQSPEFPKBNgsT8UR5qQ0y45ah+HFIBtc\n0IersJKmw+bk29XuXwMCrUCob1zfYJRgsGuechiWnUOK+rXpPHYZyCwb9Bvldqxf\nfZXGiTMwbwdPrDKGbcACJbanR2RkdsSzhu/mGNnySJ1XlbwEfekzMaqfJb452Ep6\njhXr+BDYU9jZM0+eGTr0/Nno8OkkARI5g59yXpAZS3kRH31+YOOnlI1i+NqJXMo3\nrrunGRVKQcJZC8AZIslB8VsPsuFwo2bnGZVhRFw5gQKBgQD2JrEBGa5ptJTgRizG\nY/DpmHz4Eiz/c6PUMaX85Ozd3FGpiqhNiEdmTcue0bxFJ3NtautvJJ/x/biTKT1V\nvGXaMxvNSY3zlAs994ewgv/fQuEHmu0ASrFGSv6aEEg+n36HNPGnwtEOXpoYtigx\n97UFUmtkL3q1Xt4kgzkUmZ93sQKBgQC1HBVXPp9yBi0jPxYZQNopoKgye6DPDMc0\nnEiRJufFRo6i8gXWQnGm98n5Bn3lQlb3cu7R/pYpEGFwOo6Ly+YcEj7U0dcjllBI\nIj6lDcB8/QRypIAAYAvq7+rnIHbsFV6WiiBvx9SV+DFNGrtrWTMWf9KS+/G2C/zj\nYTr9s51WpwKBgGLrX5yilm3SbTXH3byIc0tcxXPn0f+CmGbw4NTFps7t+D9bApHN\n32ukfdzASpm75e4l1qFepYxZOzCglQ58XK4YdebE1W/6oZ3weK4dpvgw5z/oKbBB\nVAZ8ot6FBpNsAywQwcB6UQsmR2UA5xxVgIC4A4JKdlSm4DzqIyk9J1GxAoGABBWc\nDZml8uZcwjy7/NnPkbzDzk+ncsPxAii8IjnkZDiRIu+eXhSlh4RzE6Cn2jHC0FXR\nOP8q18Y8zFElwdVZXSy0KgyJc44CRX4wN3y16Ju0K/m1wUxpOGUswQWkaPKabX6z\n+JFjI/ay9fAyZdtfIZTEZPg1nUtr6pzYvbv9QmUCgYAF243whL/waoHGl3NpqQ1X\nrNL3xpAs9+WcnwkTCUtqvclnZMEoKypUooDLzluN2G5bxwPYyllOI3g08GnqtW1Y\nPN4QEqRA5hx1WOxajjNXY8i8m1yO7S0tvCcicSdoiGwl8Tk6Ae+q6FjUSB0CGhYH\n1lCe5Avx/qBvfJ4pG3dNyw==\n-----END PRIVATE KEY-----\n',
    //     'client_email': 'exemplary-oven-364223@appspot.gserviceaccount.com',
    //     'client_id':
    //         '377119171510-p8tcasg9ldjo5lrofb2kkc0aiprgn9oc.apps.googleusercontent.com',
    //     'type': 'service_account'
    //   });

    //   print("Step 1");

    //   var client = await clientViaServiceAccount(credentials, scopes);
    //   var calendarApi = calendar.CalendarApi(client);
    //   var event = calendar.Event();
    //   event.summary = "Flutter Event";
    //   print("Step 2");
    //   event.start = calendar.EventDateTime(dateTime: DateTime.now());
    //   event.end = calendar.EventDateTime(
    //       dateTime: DateTime.now().add(const Duration(hours: 1)));

    //   await calendarApi.events.insert(event, 'primary');

    //   print("Event created");

    //   return true;
    // } catch (e) {
    //   debugPrint(e.toString());

    //   return false;
    // }
  }

  Future<List<TwitterModel>> getSpaces() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final spaces = await firebaseFirestore.collection("twitter").get().then(
          (value) =>
              value.docs.map((e) => TwitterModel.fromJson(e.data())).toList());
      return spaces;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<TwitterModel> getParticularSpaces({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final space = await firebaseFirestore
          .collection("twitter")
          .doc(id)
          .get()
          .then((value) => TwitterModel.fromJson(value.data()!));
      return space;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> deleteParticularSpace({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("twitter")
          .doc(id)
          .get()
          .then((value) => value.reference.delete());

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<GroupsModel> getParticularGroup({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final group = await firebaseFirestore
          .collection("announcements")
          .doc(id)
          .get()
          .then((value) => GroupsModel.fromJson(value.data()!));
      return group;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> deleteParticularGroup({required String id}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("announcements")
          .doc(id)
          .get()
          .then((value) => value.reference.delete());

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<TwitterModel>> searchSpace({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final spaces = await firebaseFirestore.collection("twitter").get().then(
          (value) =>
              value.docs.map((e) => TwitterModel.fromJson(e.data())).toList());

      return spaces
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<GroupsModel>> getGroups() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final groups = await firebaseFirestore
          .collection("announcements")
          .get()
          .then((value) =>
              value.docs.map((e) => GroupsModel.fromJson(e.data())).toList());
      return groups;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<GroupsModel>> searchGroup({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final group = await firebaseFirestore
          .collection("announcements")
          .get()
          .then((value) =>
              value.docs.map((e) => GroupsModel.fromJson(e.data())).toList());

      return group
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<File> getImage() async {
    final imagePicker = ImagePicker();
    try {
      var pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        return File(pickedImage.path);
      } else {
        throw Exception("No image selected");
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<UserModel> getUser({required String userId}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final user = await firebaseFirestore
          .collection("users")
          .doc(userId)
          .get()
          .then((value) => UserModel.fromJson(value.data()!));

      return user;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> updateUser({
    required String name,
    required String email,
    required String phone,
    required String github,
    required String linkedin,
    required String twitter,
    required String userId,
    required String technology,
    required String image,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      //* check if user exists

      
      
      await firebaseFirestore.collection("users").doc(userId).update({
        "username": name,
        "email": email,
        "phone": phone,
        "github": github,
        "linkedin": linkedin,
        "twitter": twitter,
        "userID": userId,
        "technology": technology,
        "imageUrl": image,
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<String> uploadImage({required File image}) async {
    try {
      final imageUrl = await FirebaseStorage.instance
          .ref()
          .child("images/${DateTime.now().toString()}.png")
          .putFile(image);

      return await imageUrl.ref.getDownloadURL();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<LeadsModel>> getLeads() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final leads = await firebaseFirestore.collection("lead").get().then(
          (value) =>
              value.docs.map((e) => LeadsModel.fromJson(e.data())).toList());

      return leads;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> createFeedback({
    required String feedback,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final email = await FirebaseAuth.instance.currentUser!.email;

      await firebaseFirestore.collection("feedback").add({
        "email": email,
        "feedback": feedback,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> reportProblem({
    required String title,
    required String description,
    required String appVersion,
    required String contact,
    required String image,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final email = await FirebaseAuth.instance.currentUser!.email;
      await firebaseFirestore.collection("problem").add({
        "email": email,
        "title": title,
        "description": description,
        "appVersion": appVersion,
        "contact": contact,
        "image": image,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<bool> contactDeveloper({required String email}) async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: email,
        query: encodeQueryParameters(<String, String>{
          'subject':
              'Hello there i have some information i want to get from you!',
        }),
      );

      launchUrl(emailLaunchUri);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> openLink({required String link}) async {
    try {
      if (await canLaunchUrl(Uri.parse(link.trim()))) {
        await launch(link, forceSafariVC: false);
      } else {
        throw 'Could not launch $link';
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<DeveloperModel>> getDevelopers() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final developers = await firebaseFirestore
          .collection("developers")
          .get()
          .then((value) => value.docs
              .map((e) => DeveloperModel.fromJson(e.data()))
              .toList());

      return developers;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<AnnouncementModel>> getAnnoucement() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final announcement = await firebaseFirestore
          .collection("announcement")
          .get()
          .then((value) => value.docs
              .map((e) => AnnouncementModel.fromJson(e.data()))
              .toList());

      return announcement;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Stream<List<AnnouncementModel>> getAnnoucements() async* {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final announcement = firebaseFirestore
          .collection("announcement")
          .snapshots()
          .map((event) => event.docs
              .map((e) => AnnouncementModel.fromJson(e.data()))
              .toList());

      yield* announcement;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> createResource({
    required String title,
    required String link,
    required String imageUrl,
    required String description,
    required String category,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final id = const uuid.Uuid().v1(options: {
        'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
        'clockSeq': 0x1234,
        'mSecs': DateTime.now().millisecondsSinceEpoch,
        'nSecs': 5678
      }); //

      final userId = await FirebaseAuth.instance.currentUser!.uid;

      await firebaseFirestore.collection("resource").doc(id).set({
        "id": id,
        "title": title,
        "link": link,
        "imageUrl": imageUrl,
        "description": description,
        "category": category,
        "isApproved": false,
        "userId": userId,
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> updateResource({
    required String id,
    required String title,
    required String link,
    required String imageUrl,
    required String description,
    required String category,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore.collection("resource").doc(id).update({
        "id": id,
        "title": title,
        "link": link,
        "imageUrl": imageUrl,
        "description": description,
        "category": category,
        "isApproved": true,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> createAdminResource({
    required String title,
    required String link,
    required String imageUrl,
    required String description,
    required String category,
  }) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;
      final id = const uuid.Uuid().v1(options: {
        'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
        'clockSeq': 0x1234,
        'mSecs': DateTime.now().millisecondsSinceEpoch,
        'nSecs': 5678
      }); //

      final userId = await FirebaseAuth.instance.currentUser!.uid;

      await firebaseFirestore.collection("resource").doc(id).set({
        "id": id,
        "title": title,
        "link": link,
        "imageUrl": imageUrl,
        "description": description,
        "category": category,
        "isApproved": true,
        "userId": userId,
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> copyToClipboard({required String text}) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> downloadAndSaveImage(
      {required String url, required String fileName}) async {
    try {
      final directory = await getTemporaryDirectory();
      final path = directory.path;
      await Dio().download(url, '$path/$url');
      GallerySaver.saveImage('$path/$url', albumName: "GDSC");

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future share({required String message}) async {
    try {
      await Share.share(message);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future shareEvent({required String image, required String title}) async {
    try {
      await Share.share(
          "Hey there, check out this event on GDSC App\n\n$title\n\n$image");
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future tweet({required String message}) async {
    try {
      var tweetUrl =
          'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(message)}';
      if (await canLaunch(tweetUrl)) {
        await launch(tweetUrl);
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> isUserAdmin() async {
    try {
      final userEmail = await FirebaseAuth.instance.currentUser!.email;
      final firebaseFirestore = FirebaseFirestore.instance;

      //check if user exists in the leads resources

      final lead = await firebaseFirestore
          .collection("leads")
          .where("email", isEqualTo: userEmail)
          .get()
          .then((value) =>
              value.docs.map((e) => LeadsModel.fromJson(e.data())).toList());

      if (lead.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<String> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return pickedTime!.format(context);
  }

  Future<Timestamp> selectSpaceTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    final DateTime now = DateTime.now();
    final DateTime date = DateTime(now.year, now.month, now.day);
    final DateTime dateTime = DateTime(
        date.year, date.month, date.day, pickedTime!.hour, pickedTime.minute);
    return Timestamp.fromDate(dateTime);
  }

  Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    return picked;
  }

  Future<bool> createEventNotification({
    required String title,
    required String body,
    required String image,
  }) async {
    try {
      final client = http.Client();
      const postUrl = 'https://fcm.googleapis.com/fcm/send';

      final data = {
        "to": "/topics/test",
        "mutable_content": true,
        'notification': {
          'title': title,
          'body': body,
        },
        'priority': 'high',
        'data': {
          "content": {
            "id": 1,
            "badge": 42,
            "channelKey": "event_key",
            "displayOnForeground": true,
            "notificationLayout": "BigPicture",
            "largeIcon": image,
            "bigPicture": image,
            "showWhen": false,
            "autoDismissible": true,
            "privacy": "Public",
            "payload": {"secret": "Awesome Notifications Rocks!"}
          },
          "actionButtons": [
            {"key": "REDIRECT", "label": "Redirect", "autoDismissible": true},
            {
              "key": "DISMISS",
              "label": "Dismiss",
              "actionType": "DismissAction",
              "isDangerousOption": true,
              "autoDismissible": true
            }
          ],
          "Android": {
            "content": {
              "title": "Android! The eagle has landed!",
              "payload": {"android": "android custom content!"}
            }
          },
        },
      };

      //hi there

      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAta6X3Qk:APA91bGweK3WrC4RhucqVV29O__UAyeCbu-Jen34MTdaxlzux6QvwENfPCRwoPXMDnHQJTJ_f3lsvafud24OnQzbri2o12Y_YB7dXWdPcA71aHc00Cds5ZnF_JEw6MyBdG6UUe-jBouQ',
      };

      final response = await client.post(
        Uri.parse(postUrl),
        headers: headers,
        encoding: Encoding.getByName('utf-8'),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully.');
        return true;
      } else {
        print('Notification sent failed.');
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> createAnnouncementNotification({
    required String title,
    required String body,
  }) async {
    try {
      final client = http.Client();
      const postUrl = 'https://fcm.googleapis.com/fcm/send';

      final data = {
        "to": "/topics/test",
        "mutable_content": true,
        'notification': {
          'title': title,
          'body': body,
        },
        'priority': 'high',
        'data': {
          "content": {
            "id": 1,
            "badge": 42,
            "channelKey": "announcement_key",
            "displayOnForeground": true,
            "notificationLayout": "BigPicture",
            "showWhen": false,
            "autoDismissible": true,
            "privacy": "Public",
            "payload": {"secret": "Awesome Notifications Rocks!"}
          },
          "actionButtons": [
            {"key": "REDIRECT", "label": "Redirect", "autoDismissible": true},
            {
              "key": "DISMISS",
              "label": "Dismiss",
              "actionType": "DismissAction",
              "isDangerousOption": true,
              "autoDismissible": true
            }
          ],
          "Android": {
            "content": {
              "title": "Android! The eagle has landed!",
              "payload": {"android": "android custom content!"}
            }
          },
        },
      };

      //hi there

      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAta6X3Qk:APA91bGweK3WrC4RhucqVV29O__UAyeCbu-Jen34MTdaxlzux6QvwENfPCRwoPXMDnHQJTJ_f3lsvafud24OnQzbri2o12Y_YB7dXWdPcA71aHc00Cds5ZnF_JEw6MyBdG6UUe-jBouQ',
      };

      final response = await client.post(
        Uri.parse(postUrl),
        headers: headers,
        encoding: Encoding.getByName('utf-8'),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully.');
        return true;
      } else {
        print('Notification sent failed.');
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }
}
