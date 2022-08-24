import 'dart:async';
import 'package:mc_player/enums/orientaton.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

class VideoUtil {
  static List<AssetPathEntity> _assetPathEntity = [];
  static List<AssetEntity> _videos = [];
  static int PAGE_SIZE = 20;

  static Future<List<AssetPathEntity>?> getVideoFolders() async {
    return _assetPathEntity.isEmpty
        ? (await fetchVideoFolders())
        : _assetPathEntity;
  }

  static Future<List<AssetPathEntity>?> fetchVideoFolders() async {
    PermissionState permissionState =
        await PhotoManager.requestPermissionExtend();
    if (permissionState.hasAccess) {
      _assetPathEntity.clear();
      _assetPathEntity
          .addAll(await PhotoManager.getAssetPathList(type: RequestType.video));
      return _assetPathEntity;
    }
    return [];
  }

  static Future<List<AssetEntity>> getPagedVideos(int page) async {
    List<AssetEntity> _data =
        _videos.isEmpty ? (await fetchAllVideos()) : _videos;
    print(">>>>>>>> total size: "+_data.length.toString());
    print(">>>>>>>> start : "+(page * PAGE_SIZE).toString()+">>>>>end  "+((page * PAGE_SIZE) + PAGE_SIZE - 1).toString());
    return _data
        .getRange(page * PAGE_SIZE, (page * PAGE_SIZE) + PAGE_SIZE - 1)
        .toList();
  }

  static Future<List<AssetEntity>> fetchAllVideos() async {
    await fetchVideoFolders();
    List<AssetEntity> _data = [];
    for (int i = 1; i < _assetPathEntity.length; i++) {
      AssetPathEntity element = _assetPathEntity[i];
      int count = await element.assetCountAsync;
      _data.addAll(await element.getAssetListPaged(page: 0, size: count));
    }
    _videos.clear();
    _videos.addAll(_data);
    return _videos;
  }

  Future<VideoData?> getInfo(String videoFilePath) async{
    final videoInfo = FlutterVideoInfo();
    VideoData? info = await videoInfo.getVideoInfo(videoFilePath);
    return info;
  }

  static MyOrientation getOrientation(num aspectRatio){
    return aspectRatio>1?MyOrientation.horizontal:MyOrientation.vertical;
  }

}
