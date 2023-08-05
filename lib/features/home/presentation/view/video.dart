import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lamusic/features/home/presentation/view/widgets/video_list.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/circle_loader.dart';
import '../view_model/provider/song_data.dart';


// VideoFetch videoFetch = VideoFetch();

class HomePage extends StatefulWidget {
  const HomePage({super.key, });
  @override
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Videos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: Provider.of<SongData>(context).GetDir(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return VideoList(videoList: snapshot.data);
                } else {
                  return  Center(
                    child: Column(
                      children:const [
                        const Text('No Video Found'),
                      const SizedBox(height: 10,),
                      const CircleLoading(),
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
