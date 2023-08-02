import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_bloc/Util/Widgets/no_internet_page.dart';
import 'package:gdsc_bloc/Util/route_generator.dart';
import 'package:gdsc_bloc/Util/themes.dart';
import 'package:gdsc_bloc/View/Authentication/login_page.dart';
import 'package:gdsc_bloc/View/home.dart';
import 'package:gdsc_bloc/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Blocs/app_functions_cubit/app_functions_cubit.dart';
import 'Blocs/authentication_bloc/authentication_bloc.dart';
import 'Blocs/event_bloc/event_bloc.dart';
import 'Blocs/network_bloc/network_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.instance.subscribeToTopic('test');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      Map<String, dynamic> data = message.data;
      String content = data["content"];
      final contentData = jsonDecode(content);
      final channelKey = contentData["channelKey"];
      if (channelKey == "event_key") {
        displayEventNotification(
          notification: notification,
          android: android,
          image: contentData["largeIcon"],
          channelKey: channelKey,
        );
      } else if (channelKey == "announcement_key") {
        displayAnnouncementNotification(
          notification: notification,
          android: android,
          channelKey: channelKey,
        );
      }
    }
    //call awesome notifications fcm
  });

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void displayEventNotification(
    {required RemoteNotification notification,
    required AndroidNotification android,
    required String image,
    required String channelKey}) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: channelKey,
        title: notification.title,
        body: notification.body,
        bigPicture: image,
        criticalAlert: true,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.BigPicture,
        category: NotificationCategory.Event,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'OPEN_EVENT',
          label: 'Open',
          buttonType: ActionButtonType.Default,
          enabled: true,
          icon: 'resource://drawable/logo',
        ),
      ]);
}

void displayAnnouncementNotification(
    {required RemoteNotification notification,
    required AndroidNotification android,
    required String channelKey}) {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: channelKey,
        title: notification.title,
        body: notification.body,
        criticalAlert: true,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'OPEN_ANNOUNCEMENT',
          label: 'Open',
          buttonType: ActionButtonType.Default,
          enabled: true,
          icon: 'resource://drawable/logo',
        ),
      ]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().initialize(
        'resource://drawable/logo',
        [
          NotificationChannel(
            channelGroupKey: 'event_channel',
            channelKey: 'event_key',
            channelName: 'Event Notifications',
            channelDescription: 'Notification channel for events',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: false,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
            importance: NotificationImportance.Min,
          ),
          NotificationChannel(
            channelGroupKey: 'announcement_channel',
            channelKey: 'announcement_key',
            channelName: 'announcement Notifications',
            channelDescription: 'Notification channel for announcements',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: false,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
            importance: NotificationImportance.Max,
          )
        ],
        channelGroups: [
          NotificationChannelGroup(
            channelGroupkey: 'announcement_channel',
            channelGroupName: 'announcement Channel',
          )
        ],
        debug: true);

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      receivedNotification.createdSource = NotificationSource.Local;

      if (receivedNotification.buttonKeyPressed == 'OPEN_EVENT') {
        navigatorKey.currentState!.pushNamed('/events_page');
      } else if (receivedNotification.buttonKeyPressed == 'OPEN_ANNOUNCEMENT') {
        navigatorKey.currentState!.pushNamed('/announcement_page');
      }
    });

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to show notifications'),
            actions: [
              TextButton(
                child: const Text('Don\'t Allow'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Allow'),
                onPressed: () {
                  Navigator.of(context).pop();
                  AwesomeNotifications().requestPermissionToSendNotifications();
                },
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NetworkBloc()..add(NetworkObserve()),
        ),
        BlocProvider(
          create: (context) => AuthenticationBloc()..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => EventBloc(),
        ),
        BlocProvider(
          create: (context) => AppFunctionsCubit(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        onGenerateRoute: (settings) {
          return RouteGenerator.generateRoute(settings);
        },
        themeMode: ThemeMode.dark,
        // Made for FlexColorScheme version 7.0.5. Make sure you
// use same or higher package version, but still same major version.
// If you use a lower version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
// Made for FlexColorScheme version 7.0.5. Make sure you
// use same or higher package version, but still same major version.
// If you use a lower version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
theme: FlexThemeData.light(
  primary: Color(0x14C7DEFF),
  scheme: FlexScheme.bigStone,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  appBarStyle: FlexAppBarStyle.material,
  transparentStatusBar: false,
  subThemesData: const FlexSubThemesData(
    useTextTheme: false,
    useM2StyleDividerInM3: true,
    inputDecoratorBorderType: FlexInputBorderType.underline,
    inputDecoratorUnfocusedBorderIsColored: false,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  fontFamily: GoogleFonts.inter().fontFamily,
  textTheme: lightTextTheme,
),
darkTheme: FlexThemeData.dark(
  scheme: FlexScheme.bigStone,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
   primary: Color(0xFFFFFFFF), // Replace with your desired primary color
  blendLevel: 30,
  transparentStatusBar: false,
  bottomAppBarElevation: 1.5,
  subThemesData: const FlexSubThemesData(
    useTextTheme: false,
    useM2StyleDividerInM3: true,
    inputDecoratorBorderType: FlexInputBorderType.underline,
    inputDecoratorUnfocusedBorderIsColored: false,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  fontFamily: GoogleFonts.inter().fontFamily,
  textTheme: darkTextTheme,
),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,


        debugShowCheckedModeBanner: false,
        home: BlocBuilder<NetworkBloc, NetworkState>(
          builder: (context, state) {
            if (state is NetworkFailure) {
              return NoInternet();
            } else if (state is NetworkSuccess) {
              return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationAuthenticated) {
                    return const Home();
                  } else if (state is AuthenticationUnauthenticated) {
                    return LoginPage();
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
