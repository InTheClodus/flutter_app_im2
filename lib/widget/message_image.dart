import 'dart:io';

import 'package:flutter/material.dart';

/// 消息图片
class MessageImage extends StatelessWidget {
  final String url;
  final String path;

  const MessageImage({Key key, this.url, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: path != null
          ? Image.file(
        File(path),
        fit: BoxFit.cover,
      )
          : url != null
          ? Image.network(
        url,
        fit: BoxFit.cover,
      )
          : Container(),
    );
  }
}