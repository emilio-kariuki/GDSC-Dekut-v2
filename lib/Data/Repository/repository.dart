// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gdsc_bloc/Data/Models/announcement_model.dart';
import 'package:gdsc_bloc/Data/Models/developer_model.dart';
import 'package:gdsc_bloc/Data/Models/event_model.dart';
import 'package:gdsc_bloc/Data/Models/groups_model.dart';
import 'package:gdsc_bloc/Data/Models/leads_model.dart';
import 'package:gdsc_bloc/Data/Models/message_model.dart';
import 'package:gdsc_bloc/Data/Models/resource_model.dart';
import 'package:gdsc_bloc/Data/Models/twitter_model.dart';
import 'package:gdsc_bloc/Data/Models/user_model.dart';
import 'package:gdsc_bloc/Util/shared_preference_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:uuid/uuid.dart" as uuid;
import 'package:share_plus/share_plus.dart';

class Repository {
  Future<bool> registerUser(
      {required String email,
      required String password,
      required String name}) async {
    final auth = FirebaseAuth.instance;
    try {
      User user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        await SharedPreferencesManager().setLoggedIn(value: true);
        await SharedPreferencesManager().setId(value: user.uid);
        await SharedPreferencesManager().setName(value: name);
        debugPrint("Account created Succesfull");
        return true;
      } else {
        debugPrint("Account creation failed");
        return false;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    final auth = FirebaseAuth.instance;
    try {
      User user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        await SharedPreferencesManager().setLoggedIn(value: true);
        await SharedPreferencesManager().setId(value: user.uid);
        await SharedPreferencesManager().setName(value: user.displayName!);
        debugPrint("Login Succesfull");
        return true;
      } else {
        debugPrint("Login failed");
        return false;
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> logoutUser() async {
    final auth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();
    try {
      await auth.signOut();
      await googleSignIn.signOut();
      await SharedPreferencesManager().setLoggedIn(value: false);
      debugPrint("Logout Succesfull");
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: email);
      debugPrint("Reset Password email sent Successfully");
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> changePassword(
      {required String email,
      required String oldPassword,
      required String newPassword}) async {
    final auth = FirebaseAuth.instance;
    try {
      User user = auth.currentUser!;
      final credential =
          EmailAuthProvider.credential(email: email, password: oldPassword);
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      debugPrint("Change Password Succesfull");
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
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

  Future<bool> deleteUser(
      {required String email, required String password}) async {
    final auth = FirebaseAuth.instance;
    try {
      User user = auth.currentUser!;
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(credential);
      await user.delete();
      debugPrint("Delete User Succesfull");
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // 'https://www.googleapis.com/auth/calendar',
      ],
    );
    try {
      FirebaseAuth auth = FirebaseAuth.instance;

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        print("The accessTOken is ${googleSignInAuthentication.accessToken}");
        print("The refreshToken is ${googleSignInAuthentication.idToken}");

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          await SharedPreferencesManager().setAuthAccessToken(
              value: googleSignInAuthentication.accessToken!);
          await SharedPreferencesManager()
              .setAuthRefreshToken(value: googleSignInAuthentication.idToken!);
          await SharedPreferencesManager().setLoggedIn(value: true);
          await SharedPreferencesManager()
              .setName(value: userCredential.user!.displayName!);
          await SharedPreferencesManager()
              .setId(value: userCredential.user!.uid);
          debugPrint("Login Succesfull");
          return true;
        } else {
          debugPrint("Login failed");
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<List<Event>> getEvents() async* {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final events = firebaseFirestore.collection("event").snapshots().map(
          (event) => event.docs.map((e) => Event.fromJson(e.data())).toList());

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
        "image" : image,
        "timestamp": DateTime.now().toString(),
      });
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

  Future<List<Event>> getEvent() async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final event = await firebaseFirestore.collection("event").get().then(
          (value) => value.docs.map((e) => Event.fromJson(e.data())).toList());
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

  Future<bool> deleteResource({required String title}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      await firebaseFirestore
          .collection("resource")
          .where("title", isEqualTo: title)
          .get()
          .then((value) => value.docs.first.reference.delete());

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<List<Event>> searchEvent({required String query}) async {
    try {
      final firebaseFirestore = FirebaseFirestore.instance;

      final events = await firebaseFirestore.collection("event").get().then(
          (value) => value.docs.map((e) => Event.fromJson(e.data())).toList());

      return events
          .where((element) =>
              element.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<bool> addEventToCalendar(
      {required String summary,
      required Timestamp start,
      required Timestamp end}) async {
    try {
      print("Calendar called");
      const String url =
          'https://www.googleapis.com/calendar/v3/calendars/emilio/events';

      final String accessToken =
          await SharedPreferencesManager().getAuthAccessToken();

      final Map<String, dynamic> event = {
        "summary": summary,
        "start": {
          "dateTime": start.toDate().toIso8601String(),
          "timeZone": "Nairobi"
        },
        "end": {
          "dateTime": end.toDate().toIso8601String(),
          "timeZone": "Nairobi"
        }
      };

      final String body = json.encode(event);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print(response.body);

      if (response.statusCode == 200) {
        debugPrint("event added to calendar");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());

      return false;
    }
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
      if (await canLaunchUrl(Uri.parse(link))) {
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
}
