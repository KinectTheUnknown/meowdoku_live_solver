// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoPlayerState {

 String get viewType; bool get isRegistered; bool get hasStream; int get videoWidth; int get videoHeight;
/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoPlayerStateCopyWith<VideoPlayerState> get copyWith => _$VideoPlayerStateCopyWithImpl<VideoPlayerState>(this as VideoPlayerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VideoPlayerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoPlayerState&&(identical(other.viewType, _this.viewType) || other.viewType == _this.viewType)&&(identical(other.isRegistered, _this.isRegistered) || other.isRegistered == _this.isRegistered)&&(identical(other.hasStream, _this.hasStream) || other.hasStream == _this.hasStream)&&(identical(other.videoWidth, _this.videoWidth) || other.videoWidth == _this.videoWidth)&&(identical(other.videoHeight, _this.videoHeight) || other.videoHeight == _this.videoHeight));
}


@override
int get hashCode {
  final _this = this as VideoPlayerState;
  return Object.hash(runtimeType,_this.viewType,_this.isRegistered,_this.hasStream,_this.videoWidth,_this.videoHeight);
}

@override
String toString() {
  final _this = this as VideoPlayerState;
  return 'VideoPlayerState(viewType: ${_this.viewType}, isRegistered: ${_this.isRegistered}, hasStream: ${_this.hasStream}, videoWidth: ${_this.videoWidth}, videoHeight: ${_this.videoHeight})';
}


}

/// @nodoc
abstract mixin class $VideoPlayerStateCopyWith<$Res>  {
  factory $VideoPlayerStateCopyWith(VideoPlayerState value, $Res Function(VideoPlayerState) _then) = _$VideoPlayerStateCopyWithImpl;
@useResult
$Res call({
 String viewType, bool isRegistered, bool hasStream, int videoWidth, int videoHeight
});




}
/// @nodoc
class _$VideoPlayerStateCopyWithImpl<$Res>
    implements $VideoPlayerStateCopyWith<$Res> {
  _$VideoPlayerStateCopyWithImpl(this._self, this._then);

  final VideoPlayerState _self;
  final $Res Function(VideoPlayerState) _then;

/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? viewType = null,Object? isRegistered = null,Object? hasStream = null,Object? videoWidth = null,Object? videoHeight = null,}) {
  return _then(VideoPlayerState(
viewType: null == viewType ? _self.viewType : viewType // ignore: cast_nullable_to_non_nullable
as String,isRegistered: null == isRegistered ? _self.isRegistered : isRegistered // ignore: cast_nullable_to_non_nullable
as bool,hasStream: null == hasStream ? _self.hasStream : hasStream // ignore: cast_nullable_to_non_nullable
as bool,videoWidth: null == videoWidth ? _self.videoWidth : videoWidth // ignore: cast_nullable_to_non_nullable
as int,videoHeight: null == videoHeight ? _self.videoHeight : videoHeight // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoPlayerState].
extension VideoPlayerStatePatterns on VideoPlayerState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoPlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoPlayerState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoPlayerState value)  $default,){
final _that = this;
switch (_that) {
case _VideoPlayerState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoPlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _VideoPlayerState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String viewType,  bool isRegistered,  bool hasStream,  int videoWidth,  int videoHeight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoPlayerState() when $default != null:
return $default(_that.viewType,_that.isRegistered,_that.hasStream,_that.videoWidth,_that.videoHeight);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String viewType,  bool isRegistered,  bool hasStream,  int videoWidth,  int videoHeight)  $default,) {final _that = this;
switch (_that) {
case _VideoPlayerState():
return $default(_that.viewType,_that.isRegistered,_that.hasStream,_that.videoWidth,_that.videoHeight);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String viewType,  bool isRegistered,  bool hasStream,  int videoWidth,  int videoHeight)?  $default,) {final _that = this;
switch (_that) {
case _VideoPlayerState() when $default != null:
return $default(_that.viewType,_that.isRegistered,_that.hasStream,_that.videoWidth,_that.videoHeight);case _:
  return null;

}
}

}

/// @nodoc


class _VideoPlayerState implements VideoPlayerState {
  const _VideoPlayerState({this.viewType = '', this.isRegistered = false, this.hasStream = false, this.videoWidth = 0, this.videoHeight = 0});
  

@override@JsonKey() final  String viewType;
@override@JsonKey() final  bool isRegistered;
@override@JsonKey() final  bool hasStream;
@override@JsonKey() final  int videoWidth;
@override@JsonKey() final  int videoHeight;

/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoPlayerStateCopyWith<_VideoPlayerState> get copyWith => __$VideoPlayerStateCopyWithImpl<_VideoPlayerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoPlayerState&&(identical(other.viewType, viewType) || other.viewType == viewType)&&(identical(other.isRegistered, isRegistered) || other.isRegistered == isRegistered)&&(identical(other.hasStream, hasStream) || other.hasStream == hasStream)&&(identical(other.videoWidth, videoWidth) || other.videoWidth == videoWidth)&&(identical(other.videoHeight, videoHeight) || other.videoHeight == videoHeight));
}


@override
int get hashCode {
    return Object.hash(runtimeType,viewType,isRegistered,hasStream,videoWidth,videoHeight);
}

@override
String toString() {
    return 'VideoPlayerState(viewType: $viewType, isRegistered: $isRegistered, hasStream: $hasStream, videoWidth: $videoWidth, videoHeight: $videoHeight)';
}


}

/// @nodoc
abstract mixin class _$VideoPlayerStateCopyWith<$Res> implements $VideoPlayerStateCopyWith<$Res> {
  factory _$VideoPlayerStateCopyWith(_VideoPlayerState value, $Res Function(_VideoPlayerState) _then) = __$VideoPlayerStateCopyWithImpl;
@override @useResult
$Res call({
 String viewType, bool isRegistered, bool hasStream, int videoWidth, int videoHeight
});




}
/// @nodoc
class __$VideoPlayerStateCopyWithImpl<$Res>
    implements _$VideoPlayerStateCopyWith<$Res> {
  __$VideoPlayerStateCopyWithImpl(this._self, this._then);

  final _VideoPlayerState _self;
  final $Res Function(_VideoPlayerState) _then;

/// Create a copy of VideoPlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? viewType = null,Object? isRegistered = null,Object? hasStream = null,Object? videoWidth = null,Object? videoHeight = null,}) {
  return _then(_VideoPlayerState(
viewType: null == viewType ? _self.viewType : viewType // ignore: cast_nullable_to_non_nullable
as String,isRegistered: null == isRegistered ? _self.isRegistered : isRegistered // ignore: cast_nullable_to_non_nullable
as bool,hasStream: null == hasStream ? _self.hasStream : hasStream // ignore: cast_nullable_to_non_nullable
as bool,videoWidth: null == videoWidth ? _self.videoWidth : videoWidth // ignore: cast_nullable_to_non_nullable
as int,videoHeight: null == videoHeight ? _self.videoHeight : videoHeight // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
