import 'package:flutter/material.dart';
import 'package:lamusic/core/utils/colors.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/bottomPlayer.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/searchbox.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/songs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../view_model/provider/song_data.dart';
import 'albums.dart';

class LaMusic extends StatefulWidget {
  const LaMusic({Key? key}) : super(key: key);

  @override
  State<LaMusic> createState() => _LaMusicState();
}

class _LaMusicState extends State<LaMusic> {
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
        builder: (context) => AlertDialog(
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
                'Retry',
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
    var songData = Provider.of<SongData>(context);
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:20 ,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0),
                  child: RichText(
                    text: TextSpan(
                      text: "LA",
                      style:   TextStyle(
                          color:ColorsApp.blueColor,
                          fontWeight: FontWeight.w300,
                          fontSize: 25
                      ),
                      children: const [
                        TextSpan(
                          text: "Music",
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 30
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(children: [
                    const Expanded(
                      child: SearchBox(),
                    ),
                    const SizedBox(width: 10),
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),


                  ],),
                ),
                //  ALBUMS
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0),
                  child: Albums(),
                ),
                const SizedBox(height: 5),
                Songs()
              ],
            ),
          ),

          // Bottom Player
          BottomPlayer(
            songData: songData,
          )
        ],
      ),
    );
  }
}
