
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:untitled1/feature/auth/data/model/reactions_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String body,
    @Default([]) List<String> tags,
    // 💡 এপিআই-এর nested reactions অবজেক্টকে হ্যান্ডেল করার জন্য সাব-মডেল
    ReactionsModel? reactions,
    @Default(0) int views,
    @Default(0) int userId,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

