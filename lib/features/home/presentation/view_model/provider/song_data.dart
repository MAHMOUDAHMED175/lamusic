import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lamusic/features/home/presentation/view/favourities.dart';
import 'package:lamusic/features/home/presentation/view/music.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../../hgfhgf/pages/home.dart';

class SongData with ChangeNotifier {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final player = AudioPlayer();

  List<AlbumModel>? dataOfAlbums;

  void listOfAlbums() {
    audioQuery
        .queryAlbums(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      sortType: null,
      ignoreCase: true,
    )
        .then((value) {
      dataOfAlbums = value;
    });
  }

  List<SongModel> songsSearch = [];

  void searchInSongs({required String word}) {
    audioQuery
        .querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      sortType: null,
      ignoreCase: true,
    )
        .then((value) {
      songsSearch = value
          .where((element) =>
              element.title.toLowerCase().contains(word.toLowerCase()))
          .toList();    notifyListeners();

    }).catchError((error) {
      print(error.toString());
    });
  }

  SongModel? playingSong;
  bool isPlaying = false;
  bool isPaused = false;

  setPlayingSong(SongModel song) {
    playingSong = song;
    isPlaying = true;
    isPaused = false;
    notifyListeners();
  }

  setIsPlaying(bool status) {
    isPlaying = status;
    isPaused = !status;
    notifyListeners();
  }

  bool isSongInPlaylist(
    int songId,
    int playlistId,
  ) {
    bool status = false;
    return status;
  }

  ///
  final List<SongModel> _favoritesSongs = [];

  toggleIsFav(SongModel song) {
    switch (isFav(song.id)) {
      case true:
        _favoritesSongs.removeWhere(
          (songs) => songs.id == song.id,
        );
        break;
      case false:
        _favoritesSongs.add(song);
        break;
    }
    notifyListeners();
  }

  bool isFav(int id) {
    return _favoritesSongs.any(
      (song) => song.id == id,
    );
  }

  getFavorites() {
    return [..._favoritesSongs];
  }

  ///
  ///
  ///
  ///
  ///

  List<SongModel> songList = [];
  var currentSongIndex = 0;


  setCurrentSongIndex(songIndex) {
    currentSongIndex = songIndex;
    notifyListeners();
  }

  setSongs(List<SongModel> songs) {
    songList = songs;
    notifyListeners();
  }

  int currentIndex = 0;

  List<Widget> screen = [
    const LaMusic(),
    const Vid(),
    const FavoritesScreen(),
  ];

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
