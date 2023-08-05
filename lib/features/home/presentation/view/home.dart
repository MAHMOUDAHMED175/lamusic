import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lamusic/features/home/presentation/view_model/provider/song_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  void initState() {
    requestPermission();
    super.initState();
  }

  requestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Dismiss',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Provider.of<SongData>(context)
          .screen[Provider.of<SongData>(context).currentIndex],

      bottomNavigationBar:


      Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.02),
        child: GNav(
            onTabChange: (index) {
            Provider.of<SongData>(context,listen: false).changeIndex(index);
          },
            rippleColor: Colors.orangeAccent, // tab button ripple color when pressed
            hoverColor: Colors.lightBlueAccent, // tab button hover color
            haptic: true, // haptic feedback
            tabBorderRadius: 30,
            tabActiveBorder: Border.all(color: Colors.white, width: 3), // tab button border
            tabBorder: Border.all(color: Colors.black38, width: 3), // tab button border
            tabShadow: const [BoxShadow(color: Colors.blue, blurRadius: 8)], // tab button shadow
            curve: Curves.linear, // tab animation curves
            duration: Duration(milliseconds: 900), // tab animation duration
            gap: 4, // the tab button gap between icon and text
            color: Colors.black, // unselected icon color
            activeColor: Colors.white, // selected icon and text color
            iconSize: 18, // tab button icon size
            tabBackgroundColor: Colors.orangeAccent, // selected tab background color
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), // navigation bar padding
            tabs: const [
              GButton(
                icon: FontAwesomeIcons.music,
                text: 'Music',
              ),
              GButton(
                icon:FontAwesomeIcons.video,
                text: 'Video',
              ),
              GButton(
                icon: FontAwesomeIcons.heart,
                text: 'Favorites',
              ),
            ]
        ),
      )















    );
  }
}
