import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mc_player/screens/video_screen.dart';
import 'package:mc_player/utils/data_util.dart';
import 'package:mc_player/utils/video_util.dart';
import 'package:mc_player/values/colors.dart';
import 'package:photo_manager/photo_manager.dart';

class VideoGridItem extends StatefulWidget {
  final AssetEntity video;

  const VideoGridItem(this.video, {Key? key}) : super(key: key);

  @override
  State<VideoGridItem> createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<VideoGridItem> {
  Uint8List? thumbnail;
  File? file;
  String duration = '';

  @override
  void initState() {
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kDarkGrey, borderRadius: BorderRadius.circular(8)),
      child: GestureDetector(
        onTap: onVideoClick,
        child: Column(
          children: [
            thumbnail == null
                ? CupertinoActivityIndicator()
                : Flexible(
                    child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            color: kDarkGrey,
                            borderRadius: BorderRadius.circular(8)),
                        width: (MediaQuery.of(context).size.width / 2) - 15,
                        child: Image.memory(
                          thumbnail!,
                          fit: BoxFit.cover,
                        ))),
            file == null
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,8,8,0),
                    child: Text(
                      DataUtil.getFileName(file!),
                      style: TextStyle(color: kWhite),
                    ),
                  ),
            file == null
                ? SizedBox()
                : Align(
              alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                       duration,
                        style: TextStyle(color: kGrey),
                      ),
                    ),
                )
          ],
        ),
      ),
    );
  }

  void fetch() async {
    thumbnail = await widget.video.thumbnailData;
    file = await widget.video.file;
    setState(() {});
    duration = DataUtil.formatDuration(Duration(milliseconds:int.parse((await VideoUtil().getInfo((await widget.video.file)!.path))!.duration.toString().split(".")[0])));
    setState(() {});
  }

  void onVideoClick() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return VideoScreen(file!);
    }));
  }
}
