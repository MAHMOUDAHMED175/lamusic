import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lamusic/core/utils/colors.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/song_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/widgets/loading.dart';
import '../../../view_model/provider/song_data.dart';
import '../../songs.dart';

class Songs extends StatefulWidget {
  Songs({Key? key}) : super(key: key);

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final player = AudioPlayer();
  var songsLength;

  @override
  Widget build(BuildContext context) {
    final OnAudioQuery audioQuery = OnAudioQuery();
    var songData = Provider.of<SongData>(context);
    var songList = [];

    // PLAY SONG
    _playSong(String? uri) {
      try {
        songData.player.setAudioSource(
          AudioSource.uri(
            Uri.parse(uri!),
          ),
        );
      } on Exception {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorsApp.orangeColor,
            content: Text(
              'Song can not play!',
              style: TextStyle(
                color: Colors.black,
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
    _loadNewSongOnTrack(SongModel song, songs) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              SongPlayer(
                song: song,
                player: songData.player,
                songs: songList,
                songData: songData,
              ),
        ),
      );
      songData.setSongs(songs);
      songData.setPlayingSong(song);
      _playSong(song.uri);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Songs',
                style: TextStyle(
                  color: ColorsApp.orangeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FutureBuilder<List<SongModel>>(
                      future: audioQuery.querySongs(
                        orderType: OrderType.ASC_OR_SMALLER,
                        uriType: UriType.EXTERNAL,
                        sortType: null,
                        ignoreCase: true,
                      ),
                      builder: (context, item) {
                        var songs = item.data;
                        return SongsView(songsLength: songs!.length);
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
        FutureBuilder<List<SongModel>>(
          future: audioQuery.querySongs(
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
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
                  Text(
                    'Songs are empty!',
                    style: TextStyle(
                      color: ColorsApp.orangeColor,
                    ),
                  ),
                ],
              );
            }
            songsLength = songs.length;
            songList = songs;
            return SizedBox(
              height: MediaQuery.of(context).size.height/2,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: songs.length,
                itemBuilder: (context, index) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: GestureDetector(
                        onTap: () => _loadNewSongOnTrack(songs[index], songs),
                        child: ListTile(
                          leading: songs[index] != null
                              ? QueryArtworkWidget(
                            id: songs[index].id,
                            type: ArtworkType.AUDIO,
                            artworkFit: BoxFit.cover,
                            artworkBorder: BorderRadius.circular(30),
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
                            songs[index].displayName,
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
                          trailing: GestureDetector(
                            onTap: () =>
                            {
                              if (songData.isPlaying &&
                                  songData.playingSong!.id == songs[index].id)
                                {
                                  setState(() {
                                    songData.player.playing
                                        ? _pauseSong()
                                        : _continueSong();
                                  })
                                }
                              else
                                if (songData.playingSong!.id != songs[index].id)
                                  {_loadNewSongOnTrack(songs[index], songs)}
                                else
                                  {
                                    songData.setPlayingSong(songs[index]),
                                    setState(() {
                                      _playSong(songs[index].uri);
                                    })
                                  }
                            },
                            child: Icon(
                              songData.isPlaying
                                  ? songData.playingSong!.id == songs[index].id
                                  ? songData.player.playing
                                  ? Icons.pause_circle
                                  : Icons.play_circle
                                  : Icons.play_circle
                                  : Icons.play_circle,
                              color: ColorsApp.orangeColor,
                            ),
                          ),
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
