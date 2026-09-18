// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vdo_ninja_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VdoStreamState implements DiagnosticableTreeMixin {

 VdoStreamStatus get status; String? get errorMessage; dynamic get currentStream; String? get activeStreamId;
/// Create a copy of VdoStreamState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VdoStreamStateCopyWith<VdoStreamState> get copyWith => _$VdoStreamStateCopyWithImpl<VdoStreamState>(this as VdoStreamState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as VdoStreamState;
  properties
    ..add(DiagnosticsProperty('type', 'VdoStreamState'))
    ..add(DiagnosticsProperty('status', _this.status))..add(DiagnosticsProperty('errorMessage', _this.errorMessage))..add(DiagnosticsProperty('currentStream', _this.currentStream))..add(DiagnosticsProperty('activeStreamId', _this.activeStreamId));
}

@override
bool operator ==(Object other) {
  final _this = this as VdoStreamState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VdoStreamState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&const DeepCollectionEquality().equals(other.currentStream, _this.currentStream)&&(identical(other.activeStreamId, _this.activeStreamId) || other.activeStreamId == _this.activeStreamId));
}


@override
int get hashCode {
  final _this = this as VdoStreamState;
  return Object.hash(runtimeType,_this.status,_this.errorMessage,const DeepCollectionEquality().hash(_this.currentStream),_this.activeStreamId);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as VdoStreamState;
  return 'VdoStreamState(status: ${_this.status}, errorMessage: ${_this.errorMessage}, currentStream: ${_this.currentStream}, activeStreamId: ${_this.activeStreamId})';
}


}

/// @nodoc
abstract mixin class $VdoStreamStateCopyWith<$Res>  {
  factory $VdoStreamStateCopyWith(VdoStreamState value, $Res Function(VdoStreamState) _then) = _$VdoStreamStateCopyWithImpl;
@useResult
$Res call({
 VdoStreamStatus status, String? errorMessage, dynamic currentStream, String? activeStreamId
});




}
/// @nodoc
class _$VdoStreamStateCopyWithImpl<$Res>
    implements $VdoStreamStateCopyWith<$Res> {
  _$VdoStreamStateCopyWithImpl(this._self, this._then);

  final VdoStreamState _self;
  final $Res Function(VdoStreamState) _then;

/// Create a copy of VdoStreamState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? errorMessage = freezed,Object? currentStream = freezed,Object? activeStreamId = freezed,}) {
  return _then(VdoStreamState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VdoStreamStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,currentStream: freezed == currentStream ? _self.currentStream : currentStream // ignore: cast_nullable_to_non_nullable
as dynamic,activeStreamId: freezed == activeStreamId ? _self.activeStreamId : activeStreamId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VdoStreamState].
extension VdoStreamStatePatterns on VdoStreamState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VdoStreamState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VdoStreamState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VdoStreamState value)  $default,){
final _that = this;
switch (_that) {
case _VdoStreamState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VdoStreamState value)?  $default,){
final _that = this;
switch (_that) {
case _VdoStreamState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VdoStreamStatus status,  String? errorMessage,  dynamic currentStream,  String? activeStreamId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VdoStreamState() when $default != null:
return $default(_that.status,_that.errorMessage,_that.currentStream,_that.activeStreamId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VdoStreamStatus status,  String? errorMessage,  dynamic currentStream,  String? activeStreamId)  $default,) {final _that = this;
switch (_that) {
case _VdoStreamState():
return $default(_that.status,_that.errorMessage,_that.currentStream,_that.activeStreamId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VdoStreamStatus status,  String? errorMessage,  dynamic currentStream,  String? activeStreamId)?  $default,) {final _that = this;
switch (_that) {
case _VdoStreamState() when $default != null:
return $default(_that.status,_that.errorMessage,_that.currentStream,_that.activeStreamId);case _:
  return null;

}
}

}

/// @nodoc


class _VdoStreamState extends VdoStreamState with DiagnosticableTreeMixin {
  const _VdoStreamState({this.status = VdoStreamStatus.idle, this.errorMessage, this.currentStream, this.activeStreamId}): super._();
  

@override@JsonKey() final  VdoStreamStatus status;
@override final  String? errorMessage;
@override final  dynamic currentStream;
@override final  String? activeStreamId;

/// Create a copy of VdoStreamState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VdoStreamStateCopyWith<_VdoStreamState> get copyWith => __$VdoStreamStateCopyWithImpl<_VdoStreamState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'VdoStreamState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('currentStream', currentStream))..add(DiagnosticsProperty('activeStreamId', activeStreamId));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VdoStreamState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.currentStream, currentStream)&&(identical(other.activeStreamId, activeStreamId) || other.activeStreamId == activeStreamId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,errorMessage,const DeepCollectionEquality().hash(currentStream),activeStreamId);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'VdoStreamState(status: $status, errorMessage: $errorMessage, currentStream: $currentStream, activeStreamId: $activeStreamId)';
}


}

/// @nodoc
abstract mixin class _$VdoStreamStateCopyWith<$Res> implements $VdoStreamStateCopyWith<$Res> {
  factory _$VdoStreamStateCopyWith(_VdoStreamState value, $Res Function(_VdoStreamState) _then) = __$VdoStreamStateCopyWithImpl;
@override @useResult
$Res call({
 VdoStreamStatus status, String? errorMessage, dynamic currentStream, String? activeStreamId
});




}
/// @nodoc
class __$VdoStreamStateCopyWithImpl<$Res>
    implements _$VdoStreamStateCopyWith<$Res> {
  __$VdoStreamStateCopyWithImpl(this._self, this._then);

  final _VdoStreamState _self;
  final $Res Function(_VdoStreamState) _then;

/// Create a copy of VdoStreamState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? errorMessage = freezed,Object? currentStream = freezed,Object? activeStreamId = freezed,}) {
  return _then(_VdoStreamState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VdoStreamStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,currentStream: freezed == currentStream ? _self.currentStream : currentStream // ignore: cast_nullable_to_non_nullable
as dynamic,activeStreamId: freezed == activeStreamId ? _self.activeStreamId : activeStreamId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
