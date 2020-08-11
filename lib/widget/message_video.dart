import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_im2/listener/ListenerFactory.dart';
import 'package:flutter_app_im2/page/video_player_page.dart';
import 'package:flutter_app_im2/utils/dialog_util.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/message_node/video_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

import 'message_image.dart';

/// 消息视频
class MessageVideo extends StatefulWidget {
  /// 消息实体
  final MessageEntity data;

  /// 视频节点
  final VideoMessageNode videoNode;

  /// 图片
  final String image;

  /// 视频
  final String video;

  /// 时长
  final int duration;

  const MessageVideo({
    Key key,
    this.data,
    this.videoNode,
    this.image,
    this.video,
    this.duration,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessageVideoState();
}

class MessageVideoState extends State<MessageVideo> {
  /// 缩略图文件
  String snapshotImage;

  /// 视频文件
  String video;

  @override
  void initState() {
    super.initState();

    snapshotImage = widget.image ?? widget.videoNode.videoSnapshotInfo.path;
    video = widget.video ?? widget.videoNode.videoInfo.path;

    // 添加腾讯云IM监听器，监听进度
    TencentImPlugin.addListener(tencentImListener);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      TencentImPlugin.downloadVideoImage(
        message: widget.data,
        path: snapshotImage,
      ).then((res) {
        snapshotImage = res;
        if (this.mounted) {
          this.setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    TencentImPlugin.removeListener(tencentImListener);
  }

  /// 腾讯云IM监听器
  tencentImListener(type, params) {
    if (type == ListenerTypeEnum.DownloadProgress) {
      Map<String, dynamic> obj = jsonDecode(params);
      if (widget.data == MessageEntity.fromJson(obj["message"])) {
        ListenerFactory.progressDialogChangeNotifier.value =
            obj["currentSize"] / obj["totalSize"];
      }
    }
  }

  /// 视频点击事件
  onVideoClick() async {
    // 如果视频文件为空，就下载视频
    DialogUtil.showProgressLoading(context);
    this.video = await TencentImPlugin.downloadVideo(
      message: widget.data,
      path: video,
    );
    DialogUtil.cancelLoading(context);
    if (this.mounted) {
      this.setState(() {});
    }

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new VideoPlayerPage(
          file: video,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onVideoClick,
      child: Container(
        height: 100,
        width: 100,
        child: Stack(
          children: <Widget>[
            MessageImage(path: snapshotImage),
            Align(
              alignment: new FractionalOffset(0.5, 0.5),
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 30,
              ),
            ),
            Positioned(
              right: 5,
              bottom: 5,
              child: Text(
                "${widget.duration ?? widget.videoNode.videoInfo.duration}″",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
