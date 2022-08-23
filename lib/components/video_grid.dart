import 'package:flutter/material.dart';
import 'package:mc_player/components/video_grid_item.dart';
import 'package:photo_manager/photo_manager.dart';

class VideoGrid extends StatefulWidget {
  final List<AssetEntity> videos;
  VoidCallback? onEndReached;

  VideoGrid(this.videos, {Key? key, this.onEndReached}) : super(key: key);

  @override
  State<VideoGrid> createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      widget.onEndReached!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      controller: controller,
      crossAxisCount: 2,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      children: List.generate(
          widget.videos.length, (index) => VideoGridItem(widget.videos[index])),
    );
  }
}
