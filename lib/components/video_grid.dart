import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
class VideoGrid extends StatelessWidget {
  final List<AssetEntity> videos;
  const VideoGrid(this.videos,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 2,children: List.generate(widget.videos.length, (index) => VideoGridItem(widget.videos[index])),);
  }
}
