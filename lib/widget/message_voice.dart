import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_im2/listener/ListenerFactory.dart';
import 'package:flutter_app_im2/utils/dialog_util.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/message_node/sound_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';

/// 消息语音
class MessageVoice extends StatefulWidget {
  /// 消息实体
  final MessageEntity data;

  /// 语音节点
  final SoundMessageNode soundNode;

  /// 路径
  final String path;

  /// 时间
  final int duration;

  const MessageVoice(
      {Key key, this.data, this.soundNode, this.path, this.duration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MessageVoiceState();
}

class MessageVoiceState extends State<MessageVoice> {
  /// 语音插件
  final FlutterSound flutterSound = new FlutterSound();

  /// 语音路径
  String path;

  /// 时间
  int duration;

  @override
  void initState() {
    super.initState();
    path = widget.path ?? widget.soundNode.path;
    duration = widget.duration ?? widget.soundNode.duration;

    // 添加腾讯云IM监听器，监听进度
    TencentImPlugin.addListener(tencentImListener);
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

  // 播放语音
  onPlayerOrStop() async {
    // 如果视频文件为空，就下载视频
    DialogUtil.showProgressLoading(context);
    this.path = await TencentImPlugin.downloadSound(
      message: widget.data,
      path: path,
    );
    DialogUtil.cancelLoading(context);
    if (this.mounted) {
      this.setState(() {});
    }

    if (flutterSound.isPlaying) {
      flutterSound.stopPlayer();
    } else {
      flutterSound.startPlayer(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPlayerOrStop,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.subject),
          Text("$duration ″"),
        ],
      ),
    );
  }
}
