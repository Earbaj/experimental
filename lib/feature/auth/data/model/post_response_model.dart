
import 'package:freezed_annotation/freezed_annotation.dart';
import 'post_model.dart';

part 'post_response_model.freezed.dart';
part 'post_response_model.g.dart';

@freezed
class PostResponseModel with _$PostResponseModel {
  const factory PostResponseModel({
    @Default([]) List<PostModel> posts,
    @Default(0) int total,
    @Default(0) int skip,
    @Default(0) int limit,
  }) = _PostResponseModel;

  factory PostResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostResponseModelFromJson(json);
}