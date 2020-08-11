import 'package:tencent_im_plugin/entity/message_entity.dart';

/// 数据实体
class DataEntity {
  /// 消息实体
  final MessageEntity data;

  /// 进度
  final int progress;

  DataEntity({
    this.data,
    this.progress,
  });
}