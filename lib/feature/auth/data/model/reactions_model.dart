import 'package:freezed_annotation/freezed_annotation.dart';

part 'reactions_model.freezed.dart';
part 'reactions_model.g.dart';

@freezed
class ReactionsModel with _$ReactionsModel {
  const factory ReactionsModel({
    @Default(0) int likes,
    @Default(0) int dislikes,
  }) = _ReactionsModel;

  factory ReactionsModel.fromJson(Map<String, dynamic> json) =>
      _$ReactionsModelFromJson(json);
}