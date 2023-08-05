import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lamusic/core/utils/colors.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/albums.dart';
import 'package:lamusic/core/widgets/kText.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/songs_by_album.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../core/widgets/loading.dart';

class Albums extends StatefulWidget {
  Albums({Key? key}) : super(key: key);

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  var albumsLength = 0;

  @override
  Widget build(BuildContext context) {
    final OnAudioQuery audioQuery = OnAudioQuery();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const KText(
                firstText: 'All',
                secondText: ' Albums',
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FutureBuilder<List<AlbumModel>>(
                      future: audioQuery.queryAlbums(
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        // sortType: AlbumSortType.ARTIST,
                        ignoreCase: true,
                      ),
                      builder: (context, item) {
                        var albums = item.data;
                        return AlbumsView(album: albums!.length);
                      },
                    ),
                  ));
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: ColorsApp.blueColor,
                  ),
                ),
              )
            ],
          ),
        ),
        FutureBuilder<List<AlbumModel>>(
          future: audioQuery.queryAlbums(
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            // sortType: AlbumSortType.ARTIST,
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
                      color: ColorsApp.whiteColor,
                    ),
                  ),
                ],
              );
            }
            albumsLength = albums.length;
            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: albumsLength,
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: QueryArtworkWidget(
                            id: albums[index].id,
                            type: ArtworkType.ALBUM,
                            nullArtworkWidget: Icon(
                              Icons.album,
                              size: 40,
                              color: ColorsApp.blueColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 50,
                          child: Text(
                            '${albums[index].album}..',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
