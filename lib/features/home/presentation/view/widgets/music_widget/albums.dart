import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lamusic/core/utils/colors.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/songs_by_album.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/searchbox.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../../../core/widgets/kBackground.dart';
import '../../../../../../core/widgets/kText.dart';
import '../../../../../../core/widgets/loading.dart';

class AlbumsView extends StatefulWidget {

  AlbumsView({Key? key,required this.album}) : super(key: key);
  int album;

  @override
  State<AlbumsView> createState() => _AlbumsViewState();
}

class _AlbumsViewState extends State<AlbumsView> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: ColorsApp.orangeColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 18.0,
            top:35.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 25,
                        width: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsApp.orangeColor,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.chevron_left,
                            color: ColorsApp.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                      height: 60,
                      width: 60,
                      child: Image.asset('assets/images/logo.png')),
                ],
              ),
              const SizedBox(height: 10),
              const SearchBox(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const KText(
                    firstText: 'All',
                    secondText: ' Albums',
                  ),
                  Text(
                    '${widget.album} albums ',
                    style:GoogleFonts.adamina(
                      color: ColorsApp.blueColor
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<AlbumModel>>(
                future: audioQuery.queryAlbums(
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  sortType: null,
                  ignoreCase: true,
                ),
                builder: (context, item) {
                  var albums = item.data;
                  if (albums == null) {
                    return const Center(
                      child: Loading(),
                    );
                  }
                  if (albums.isEmpty) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty.png',
                          width: 90,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Albums are empty!',
                          style: TextStyle(
                            color: ColorsApp.orangeColor,
                          ),
                        ),
                      ],
                    );
                  }
                  return SizedBox(
                      height: size.height / 1.3,
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 20,top: 20),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 3 : 4,
                          mainAxisSpacing: 35,
                          crossAxisSpacing: 20,
                        ),
                        itemCount: albums.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AlbumSongs(
                                  index: index,
                                )));
                            Timer(
                              Duration(milliseconds: 50),
                                  () {
                                setState(() {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AlbumSongs(
                                        index: index,
                                      )));
                                });
                              },
                            );
                          },


                          child: Column(
                            children: [
                              QueryArtworkWidget(
                                id: albums[index].id,
                                type: ArtworkType.ALBUM,
                                artworkFit: BoxFit.cover,
                                // artworkHeight: 80,
                                artworkWidth: double.infinity,
                                nullArtworkWidget: Icon(Icons.album,
                                    color: ColorsApp.blueColor, size: 40),
                                artworkBorder: BorderRadius.circular(5),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                albums[index].album,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
