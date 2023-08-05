import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lamusic/core/utils/colors.dart';
import 'package:lamusic/core/utils/styles.dart';
import '../video_view.dart';

class VideoList extends StatefulWidget {
  final List<File> videoList;
  const VideoList({super.key, required this.videoList});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
        
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30)
            ),
            child: ListView.builder(
              itemCount: widget.videoList.length,
              itemBuilder: (BuildContext context, int index) {
                final videoName =
                    widget.videoList[index].path.split("/").last.split(".").first;
                return InkWell(
                     onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return VideoView(
                                video: File(
                                  widget.videoList[index].path,
                                ),
                              );
                            },
                          ),
                        );
                        // print(Video_name);
                      },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      children: [
                        Row(
                
                          children: [
                            Icon(FontAwesomeIcons.video,color: ColorsApp.blueColor,),
                            const SizedBox(width: 10,),
                              Expanded(
                               child: Text(
                                  '$videoName',
                                  
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
                        Divider(thickness: 3,color: ColorsApp.orangeColor,height: 2,),
                
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
