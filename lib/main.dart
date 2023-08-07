
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lamusic/confg/cacheHelper.dart';
import 'package:lamusic/confg/theme.dart';
import 'package:lamusic/features/home/presentation/view/home.dart';
import 'package:lamusic/features/home/presentation/view_model/provider/song_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'core/utils/colors.dart';
import 'features/register_login/presentation/view/auth/auth.dart';
import 'features/register_login/presentation/view/splash/splash.dart';
import 'features/register_login/presentation/view_model/managers/provider/internet_provider.dart';
import 'features/register_login/presentation/view_model/managers/provider/music_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.Initi();

  late var onBoarding = CacheHelper.getData(key: "onBoarding");
  Widget widget;
  bool? token = CacheHelper.getData(key: "token");
  if (onBoarding != null) {
    if (token != null) {
      widget =
          const Home();
    } else {
      widget = const AuthPage();
    }
  } else {
    widget = const OnBoardingScreen();
  }
  //  JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  //   preloadArtwork: true,
  //   notificationColor: Colors.deepPurpleAccent,
  //   androidNotificationIcon: 'assets/images/only_logo.png'
  // );
  runApp(MyApp(widget: widget,));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key, required this.widget}) : super(key: key);

  Widget? widget;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  requestPermission() async {
    var status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      // If the permission is denied or permanently denied, request it again.
      // You can also show an explanation to the user before requesting.
      // For permanently denied status, you can navigate the user to app settings.
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Wrap(
                children: [
                  Icon(
                    Icons.music_note,
                    size: 30,
                    color: ColorsApp.orangeColor,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'LAMusic',
                    style: TextStyle(
                      color: ColorsApp.orangeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              content: const Text(
                'Access Denied! Music from storage will not be fetched',
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                  ),
                  onPressed: () {
                    // Request the storage permission again
                    requestPermission();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'hjgt',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
      );
    } else if (status.isGranted) {
      // Permission is granted, proceed with the app logic.
      print("Storage permission is granted!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MusicProvider>(
          create: ((context) => MusicProvider()),
        ),
        ChangeNotifierProvider<InternetProvider>(
          create: ((context) => InternetProvider()),
        ),
        ChangeNotifierProvider<SongData>(
          create: ((context) => SongData()),
        ),
      ],
      child: MaterialApp(
        theme: darkTheme,
        // home:Home(),
        home: widget.widget,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
