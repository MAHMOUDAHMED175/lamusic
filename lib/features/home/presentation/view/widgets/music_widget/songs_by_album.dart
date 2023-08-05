import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lamusic/core/utils/colors.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/song_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/kText.dart';
import '../../../../../../core/widgets/loading.dart';
import '../../../view_model/provider/song_data.dart';
import 'bottomPlayer.dart';


class AlbumSongs extends StatefulWidget {
  AlbumSongs({Key? key, required this.index}) : super(key: key);
  final int?  index;

  @override
  State<AlbumSongs> createState() => _AlbumSongsState();
}

class _AlbumSongsState extends State<AlbumSongs> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  int? index;

  @override
  void initState() {
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<SongData>(context).listOfAlbums();
    var songData = Provider.of<SongData>(context);
    var songList = [];

    // PLAY SONG
    _playSong(SongModel song) {
      try {
        songData.player.setAudioSource(
          AudioSource.uri(
            Uri.parse(song.uri!),
            // tag: MediaItem(
            //   id: '${song.id}',
            //   // Metadata to display in the notification:
            //   artist: song.artist,
            //   duration: Duration(minutes: song.duration!),
            //   title: song.title,
            //   album: song.album,
            //   artUri: Uri.parse(song.uri!),
            // ),
          ),
        );
      } on Exception {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorsApp.orangeColor,
            content: Text(
              'Song can not play!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }

    // CONTINUE SONG
    _continueSong() {
      songData.player.play();
    }

    // PAUSE SONG
    _pauseSong() {
      songData.player.pause();
    }

    // Fnc for loading new music on track and taking them to the song_player screen
    _loadNewSongOnTrack(
      SongModel song,
      List<SongModel> songs,
    ) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SongPlayer(
            song: song,
            player: songData.player,
            songs: songList,
            songData: songData,
          ),
        ),
      );
      songData.setSongs(songs);
      songData.setPlayingSong(song);
      _playSong(song);
    }

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
      body: Padding(
        padding: const EdgeInsets.only(
          top: 50.0,
        ),
        child: Stack(

          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: SingleChildScrollView(
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
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 20,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: KText(
                              firstText: 'Songs by ',
                              secondText:
                                  '${songData.dataOfAlbums![widget.index!].artist} Album',
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: QueryArtworkWidget(
                        id: songData.dataOfAlbums![index!].id,
                        type: ArtworkType.ALBUM,
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: Icon(
                          Icons.album,
                          color: ColorsApp.blueColor,
                          size: 63,
                        ),
                        artworkBorder: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      child: FutureBuilder<List<SongModel>>(
                        future: audioQuery.queryAudiosFrom(
                          AudiosFromType.ALBUM_ID,
                          songData.dataOfAlbums![index!].id,
                          orderType: OrderType.ASC_OR_SMALLER,
                          sortType: null,
                          ignoreCase: true,
                        ),
                        builder: (context, item) {
                          var songs = item.data;
                          if (songs == null) {
                            return const Center(
                              child: Loading(),
                            );
                          }
                          if (songs.isEmpty) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/empty.png',
                                  width: 90,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Songs are empty!',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            );
                          }
                          songList = songs;

                          return SizedBox(
                            height: size.height / 1.5,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: songs.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () =>
                                      _loadNewSongOnTrack(songs[index], songs),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: songs[index] != null
                                        ? QueryArtworkWidget(
                                            id: songs[index].id,
                                            type: ArtworkType.AUDIO,
                                            artworkFit: BoxFit.cover,
                                            artworkBorder:
                                                BorderRadius.circular(30),
                                            nullArtworkWidget: Icon(
                                              Icons.music_note,
                                              color: ColorsApp.orangeColor,
                                            ),
                                          )
                                        : Icon(
                                            Icons.music_note,
                                            color: ColorsApp.orangeColor,
                                          ),
                                    title: Text(
                                      songs[index].title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      songs[index].artist!,
                                      style: TextStyle(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    trailing: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => songData
                                              .toggleIsFav(songs[index]),
                                          child: Icon(
                                            songData.isFav(songs[index].id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                songData.isFav(songs[index].id)
                                                    ? Colors.red
                                                    : Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        GestureDetector(
                                          onTap: () => {
                                            if (songData.isPlaying &&
                                                songData.playingSong!.id ==
                                                    songs[index].id)
                                              {
                                                setState(() {
                                                  songData.player.playing
                                                      ? _pauseSong()
                                                      : _continueSong();
                                                })
                                              }
                                            else if (songData.playingSong!.id !=
                                                songs[index].id)
                                              {
                                                _loadNewSongOnTrack(
                                                    songs[index], songs)
                                              }
                                            else
                                              {
                                                songData.setPlayingSong(
                                                    songs[index]),
                                                setState(() {
                                                  _playSong(songs[index]);
                                                })
                                              }
                                          },
                                          child: Icon(
                                            songData.isPlaying
                                                ? songData.playingSong!.id ==
                                                        songs[index].id
                                                    ? songData.player.playing
                                                        ? Icons.pause_circle
                                                        : Icons.play_circle
                                                    : Icons.play_circle
                                                : Icons.play_circle,
                                            color: ColorsApp.orangeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Player
            songData.isPlaying
                ? BottomPlayer(
                    songData: songData,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
