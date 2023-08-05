import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lamusic/core/widgets/circle_loader.dart';
import 'package:lamusic/core/widgets/loading.dart';
import 'package:lamusic/features/home/presentation/view/widgets/music_widget/song_player.dart';
import 'package:lamusic/features/home/presentation/view_model/provider/song_data.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/colors.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    var songData = Provider.of<SongData>(context);
    var songList = [];

    _playSong(SongModel song) {
      try {
        songData.player.setAudioSource(
          AudioSource.uri(
            Uri.parse(song.uri!),
            // tag: MediaItem(
            //   // Specify a unique ID for each media item:
            //   id: '${song.id}',
            //   // Metadata to display in the notification:
            //   artist: song.artist,
            //   duration: Duration(minutes: song.duration!),
            //   title: song.title,
            //   album: song.album,
            //   // artUri: Uri.parse(song.uri!),
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

    _continueSong() {
      setState(() {
        songData.player.play();
        songData.setIsPlaying(true);
      });
    }

    // PAUSE SONG
    _pauseSong() {
      setState(() {
        songData.player.pause();
        songData.setIsPlaying(false);
      });
    }

    // Fnc for loading new music on track and taking them to the song_player screen
    _loadNewSongOnTrack(
        SongModel song,
        List<SongModel> songs,
        ) {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => SongPlayer(
            song: song,
            player: songData.player,
            songs: songList,
            songData: songData,
          ),
        ),
      )
          .then((value) => setState(() {}));
      songData.setSongs(songs);
      songData.setPlayingSong(song);
      _playSong(song);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SearchTextFormFieldView(),
            Provider.of<SongData>(context).songsSearch.isNotEmpty
                ? Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              _loadNewSongOnTrack(Provider.of<SongData>(context, listen: false).songsSearch[index],Provider.of<SongData>(context, listen: false). songsSearch);
                            },
                            child:Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                children: [
                                  Row(

                                    children: [
                                      Icon(FontAwesomeIcons.music,color: ColorsApp.blueColor,),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Text(
                                          Provider.of<SongData>(context).songsSearch[index].title,

                                          style:const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      Icon(FontAwesomeIcons.arrowRight,color: ColorsApp.orangeColor,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Container(
                              height: 1,
                              color: Colors.white,
                            ),
                        itemCount:
                            Provider.of<SongData>(context).songsSearch.length),
                  )
                : Expanded(
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Search'),
                      SizedBox(height:30),
                     Loading (),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class SearchTextFormFieldView extends StatefulWidget {
  @override
  State<SearchTextFormFieldView> createState() => _SearchTextFormFieldViewState();
}

class _SearchTextFormFieldViewState extends State<SearchTextFormFieldView> {
  var searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchText,
      onChanged: (value) {
        Provider.of<SongData>(context,listen: false).searchInSongs(word: value);

      },
      onSubmitted: (value) {
        Provider.of<SongData>(context,listen: false).searchInSongs(word: value);
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10),
        hintText: 'Search',
        hintStyle: const TextStyle(
          color: Colors.black,
        ),
        suffixIcon:IconButton(
                onPressed: () {
                  searchText.text = "";
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
              ),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.black,
        ),
        fillColor: ColorsApp.orangeColor.withOpacity(0.8),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.lightBlueAccent,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
