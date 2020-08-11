import 'package:flutter/material.dart';
import 'package:flutter_app_im2/model/DataEntity.dart';
import 'package:tencent_im_plugin/enums/message_status_enum.dart';

/// 消息条目
class MessageItem extends StatelessWidget {
  /// 消息对象
  final DataEntity data;

  /// 子组件
  final Widget child;

  const MessageItem({
    Key key,
    this.data,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          !data.data.self
              ? Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: data.data.userInfo.faceUrl == null
                    ? null
                    : Image.network(
                  data.data.userInfo.faceUrl,
                  fit: BoxFit.cover,
                ).image,
              ),
              Container(width: 5),
            ],
          )
              : Container(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: data.data.self
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Text(data.data.userInfo.nickName ?? ""),
                Container(height: 5),
                Container(
                  padding: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 7,
                    right: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: data != null &&
                      data.data.status == MessageStatusEnum.HasRevoked
                      ? Text("[该消息已被撤回]")
                      : child,
                ),
                Container(),
                data.progress != null && data.progress < 100
                    ? Text("${data.progress}%")
                    : Container(),
              ],
            ),
          ),
          data.data.self
              ? Row(
            children: <Widget>[
              Container(width: 5),
              CircleAvatar(
                backgroundImage: data.data.userInfo.faceUrl == null
                    ? null
                    : Image.network(
                  data.data.userInfo.faceUrl,
                  fit: BoxFit.cover,
                ).image,
              ),
            ],
          )
              : Container(),
        ],
      ),
    );
  }
}