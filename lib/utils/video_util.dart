import 'package:photo_manager/photo_manager.dart';

class VideoUtil{
  static List<AssetPathEntity>? _assetPathEntity;
  static int PAGE_SIZE = 20;
  static Future<List<AssetEntity>?> fetchVideos(int page) async{
    PermissionState permissionState = await PhotoManager.requestPermissionExtend();
    if(permissionState.hasAccess) {
      _assetPathEntity = _assetPathEntity ?? (await PhotoManager.getAssetPathList(type: RequestType.video));
      return _assetPathEntity![0].getAssetListPaged(page: page, size: PAGE_SIZE);
    }
    return [];
  }
}