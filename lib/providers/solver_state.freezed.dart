// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'solver_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SolverState {

 VisionExtractionResult? get visionResult; SolverResult? get solverResult; PuzzleBoard? get currentBoard; List<BoardCoordinate> get solutionQueens; List<BoardCoordinate> get fixedQueens; Duration? get lastSolveDuration; bool get isProcessing; bool get autoSolveEnabled; double get autoSolveIntervalSec; bool get ignoreExistingQueens; bool get showCalibration; SolutionBadgeStyle get badgeStyle; int? get manualGridN; int get cacheHits; int get cacheMisses; int get cacheSize;
/// Create a copy of SolverState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SolverStateCopyWith<SolverState> get copyWith => _$SolverStateCopyWithImpl<SolverState>(this as SolverState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SolverState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SolverState&&(identical(other.visionResult, _this.visionResult) || other.visionResult == _this.visionResult)&&(identical(other.solverResult, _this.solverResult) || other.solverResult == _this.solverResult)&&(identical(other.currentBoard, _this.currentBoard) || other.currentBoard == _this.currentBoard)&&const DeepCollectionEquality().equals(other.solutionQueens, _this.solutionQueens)&&const DeepCollectionEquality().equals(other.fixedQueens, _this.fixedQueens)&&(identical(other.lastSolveDuration, _this.lastSolveDuration) || other.lastSolveDuration == _this.lastSolveDuration)&&(identical(other.isProcessing, _this.isProcessing) || other.isProcessing == _this.isProcessing)&&(identical(other.autoSolveEnabled, _this.autoSolveEnabled) || other.autoSolveEnabled == _this.autoSolveEnabled)&&(identical(other.autoSolveIntervalSec, _this.autoSolveIntervalSec) || other.autoSolveIntervalSec == _this.autoSolveIntervalSec)&&(identical(other.ignoreExistingQueens, _this.ignoreExistingQueens) || other.ignoreExistingQueens == _this.ignoreExistingQueens)&&(identical(other.showCalibration, _this.showCalibration) || other.showCalibration == _this.showCalibration)&&(identical(other.badgeStyle, _this.badgeStyle) || other.badgeStyle == _this.badgeStyle)&&(identical(other.manualGridN, _this.manualGridN) || other.manualGridN == _this.manualGridN)&&(identical(other.cacheHits, _this.cacheHits) || other.cacheHits == _this.cacheHits)&&(identical(other.cacheMisses, _this.cacheMisses) || other.cacheMisses == _this.cacheMisses)&&(identical(other.cacheSize, _this.cacheSize) || other.cacheSize == _this.cacheSize));
}


@override
int get hashCode {
  final _this = this as SolverState;
  return Object.hash(runtimeType,_this.visionResult,_this.solverResult,_this.currentBoard,const DeepCollectionEquality().hash(_this.solutionQueens),const DeepCollectionEquality().hash(_this.fixedQueens),_this.lastSolveDuration,_this.isProcessing,_this.autoSolveEnabled,_this.autoSolveIntervalSec,_this.ignoreExistingQueens,_this.showCalibration,_this.badgeStyle,_this.manualGridN,_this.cacheHits,_this.cacheMisses,_this.cacheSize);
}

@override
String toString() {
  final _this = this as SolverState;
  return 'SolverState(visionResult: ${_this.visionResult}, solverResult: ${_this.solverResult}, currentBoard: ${_this.currentBoard}, solutionQueens: ${_this.solutionQueens}, fixedQueens: ${_this.fixedQueens}, lastSolveDuration: ${_this.lastSolveDuration}, isProcessing: ${_this.isProcessing}, autoSolveEnabled: ${_this.autoSolveEnabled}, autoSolveIntervalSec: ${_this.autoSolveIntervalSec}, ignoreExistingQueens: ${_this.ignoreExistingQueens}, showCalibration: ${_this.showCalibration}, badgeStyle: ${_this.badgeStyle}, manualGridN: ${_this.manualGridN}, cacheHits: ${_this.cacheHits}, cacheMisses: ${_this.cacheMisses}, cacheSize: ${_this.cacheSize})';
}


}

/// @nodoc
abstract mixin class $SolverStateCopyWith<$Res>  {
  factory $SolverStateCopyWith(SolverState value, $Res Function(SolverState) _then) = _$SolverStateCopyWithImpl;
@useResult
$Res call({
 VisionExtractionResult? visionResult, SolverResult? solverResult, PuzzleBoard? currentBoard, List<BoardCoordinate> solutionQueens, List<BoardCoordinate> fixedQueens, Duration? lastSolveDuration, bool isProcessing, bool autoSolveEnabled, double autoSolveIntervalSec, bool ignoreExistingQueens, bool showCalibration, SolutionBadgeStyle badgeStyle, int? manualGridN, int cacheHits, int cacheMisses, int cacheSize
});




}
/// @nodoc
class _$SolverStateCopyWithImpl<$Res>
    implements $SolverStateCopyWith<$Res> {
  _$SolverStateCopyWithImpl(this._self, this._then);

  final SolverState _self;
  final $Res Function(SolverState) _then;

/// Create a copy of SolverState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? visionResult = freezed,Object? solverResult = freezed,Object? currentBoard = freezed,Object? solutionQueens = null,Object? fixedQueens = null,Object? lastSolveDuration = freezed,Object? isProcessing = null,Object? autoSolveEnabled = null,Object? autoSolveIntervalSec = null,Object? ignoreExistingQueens = null,Object? showCalibration = null,Object? badgeStyle = null,Object? manualGridN = freezed,Object? cacheHits = null,Object? cacheMisses = null,Object? cacheSize = null,}) {
  return _then(SolverState(
visionResult: freezed == visionResult ? _self.visionResult : visionResult // ignore: cast_nullable_to_non_nullable
as VisionExtractionResult?,solverResult: freezed == solverResult ? _self.solverResult : solverResult // ignore: cast_nullable_to_non_nullable
as SolverResult?,currentBoard: freezed == currentBoard ? _self.currentBoard : currentBoard // ignore: cast_nullable_to_non_nullable
as PuzzleBoard?,solutionQueens: null == solutionQueens ? _self.solutionQueens : solutionQueens // ignore: cast_nullable_to_non_nullable
as List<BoardCoordinate>,fixedQueens: null == fixedQueens ? _self.fixedQueens : fixedQueens // ignore: cast_nullable_to_non_nullable
as List<BoardCoordinate>,lastSolveDuration: freezed == lastSolveDuration ? _self.lastSolveDuration : lastSolveDuration // ignore: cast_nullable_to_non_nullable
as Duration?,isProcessing: null == isProcessing ? _self.isProcessing : isProcessing // ignore: cast_nullable_to_non_nullable
as bool,autoSolveEnabled: null == autoSolveEnabled ? _self.autoSolveEnabled : autoSolveEnabled // ignore: cast_nullable_to_non_nullable
as bool,autoSolveIntervalSec: null == autoSolveIntervalSec ? _self.autoSolveIntervalSec : autoSolveIntervalSec // ignore: cast_nullable_to_non_nullable
as double,ignoreExistingQueens: null == ignoreExistingQueens ? _self.ignoreExistingQueens : ignoreExistingQueens // ignore: cast_nullable_to_non_nullable
as bool,showCalibration: null == showCalibration ? _self.showCalibration : showCalibration // ignore: cast_nullable_to_non_nullable
as bool,badgeStyle: null == badgeStyle ? _self.badgeStyle : badgeStyle // ignore: cast_nullable_to_non_nullable
as SolutionBadgeStyle,manualGridN: freezed == manualGridN ? _self.manualGridN : manualGridN // ignore: cast_nullable_to_non_nullable
as int?,cacheHits: null == cacheHits ? _self.cacheHits : cacheHits // ignore: cast_nullable_to_non_nullable
as int,cacheMisses: null == cacheMisses ? _self.cacheMisses : cacheMisses // ignore: cast_nullable_to_non_nullable
as int,cacheSize: null == cacheSize ? _self.cacheSize : cacheSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SolverState].
extension SolverStatePatterns on SolverState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SolverState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SolverState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SolverState value)  $default,){
final _that = this;
switch (_that) {
case _SolverState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SolverState value)?  $default,){
final _that = this;
switch (_that) {
case _SolverState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VisionExtractionResult? visionResult,  SolverResult? solverResult,  PuzzleBoard? currentBoard,  List<BoardCoordinate> solutionQueens,  List<BoardCoordinate> fixedQueens,  Duration? lastSolveDuration,  bool isProcessing,  bool autoSolveEnabled,  double autoSolveIntervalSec,  bool ignoreExistingQueens,  bool showCalibration,  SolutionBadgeStyle badgeStyle,  int? manualGridN,  int cacheHits,  int cacheMisses,  int cacheSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SolverState() when $default != null:
return $default(_that.visionResult,_that.solverResult,_that.currentBoard,_that.solutionQueens,_that.fixedQueens,_that.lastSolveDuration,_that.isProcessing,_that.autoSolveEnabled,_that.autoSolveIntervalSec,_that.ignoreExistingQueens,_that.showCalibration,_that.badgeStyle,_that.manualGridN,_that.cacheHits,_that.cacheMisses,_that.cacheSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VisionExtractionResult? visionResult,  SolverResult? solverResult,  PuzzleBoard? currentBoard,  List<BoardCoordinate> solutionQueens,  List<BoardCoordinate> fixedQueens,  Duration? lastSolveDuration,  bool isProcessing,  bool autoSolveEnabled,  double autoSolveIntervalSec,  bool ignoreExistingQueens,  bool showCalibration,  SolutionBadgeStyle badgeStyle,  int? manualGridN,  int cacheHits,  int cacheMisses,  int cacheSize)  $default,) {final _that = this;
switch (_that) {
case _SolverState():
return $default(_that.visionResult,_that.solverResult,_that.currentBoard,_that.solutionQueens,_that.fixedQueens,_that.lastSolveDuration,_that.isProcessing,_that.autoSolveEnabled,_that.autoSolveIntervalSec,_that.ignoreExistingQueens,_that.showCalibration,_that.badgeStyle,_that.manualGridN,_that.cacheHits,_that.cacheMisses,_that.cacheSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VisionExtractionResult? visionResult,  SolverResult? solverResult,  PuzzleBoard? currentBoard,  List<BoardCoordinate> solutionQueens,  List<BoardCoordinate> fixedQueens,  Duration? lastSolveDuration,  bool isProcessing,  bool autoSolveEnabled,  double autoSolveIntervalSec,  bool ignoreExistingQueens,  bool showCalibration,  SolutionBadgeStyle badgeStyle,  int? manualGridN,  int cacheHits,  int cacheMisses,  int cacheSize)?  $default,) {final _that = this;
switch (_that) {
case _SolverState() when $default != null:
return $default(_that.visionResult,_that.solverResult,_that.currentBoard,_that.solutionQueens,_that.fixedQueens,_that.lastSolveDuration,_that.isProcessing,_that.autoSolveEnabled,_that.autoSolveIntervalSec,_that.ignoreExistingQueens,_that.showCalibration,_that.badgeStyle,_that.manualGridN,_that.cacheHits,_that.cacheMisses,_that.cacheSize);case _:
  return null;

}
}

}

/// @nodoc


class _SolverState implements SolverState {
  const _SolverState({this.visionResult, this.solverResult, this.currentBoard,  List<BoardCoordinate> solutionQueens = const [],  List<BoardCoordinate> fixedQueens = const [], this.lastSolveDuration, this.isProcessing = false, this.autoSolveEnabled = false, this.autoSolveIntervalSec = 1.0, this.ignoreExistingQueens = false, this.showCalibration = true, this.badgeStyle = SolutionBadgeStyle.catFace, this.manualGridN, this.cacheHits = 0, this.cacheMisses = 0, this.cacheSize = 0}): _solutionQueens = solutionQueens,_fixedQueens = fixedQueens;
  

@override final  VisionExtractionResult? visionResult;
@override final  SolverResult? solverResult;
@override final  PuzzleBoard? currentBoard;
 final  List<BoardCoordinate> _solutionQueens;
@override@JsonKey() List<BoardCoordinate> get solutionQueens {
  if (_solutionQueens is EqualUnmodifiableListView) return _solutionQueens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_solutionQueens);
}

 final  List<BoardCoordinate> _fixedQueens;
@override@JsonKey() List<BoardCoordinate> get fixedQueens {
  if (_fixedQueens is EqualUnmodifiableListView) return _fixedQueens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fixedQueens);
}

@override final  Duration? lastSolveDuration;
@override@JsonKey() final  bool isProcessing;
@override@JsonKey() final  bool autoSolveEnabled;
@override@JsonKey() final  double autoSolveIntervalSec;
@override@JsonKey() final  bool ignoreExistingQueens;
@override@JsonKey() final  bool showCalibration;
@override@JsonKey() final  SolutionBadgeStyle badgeStyle;
@override final  int? manualGridN;
@override@JsonKey() final  int cacheHits;
@override@JsonKey() final  int cacheMisses;
@override@JsonKey() final  int cacheSize;

/// Create a copy of SolverState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SolverStateCopyWith<_SolverState> get copyWith => __$SolverStateCopyWithImpl<_SolverState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SolverState&&(identical(other.visionResult, visionResult) || other.visionResult == visionResult)&&(identical(other.solverResult, solverResult) || other.solverResult == solverResult)&&(identical(other.currentBoard, currentBoard) || other.currentBoard == currentBoard)&&const DeepCollectionEquality().equals(other.solutionQueens, _solutionQueens)&&const DeepCollectionEquality().equals(other.fixedQueens, _fixedQueens)&&(identical(other.lastSolveDuration, lastSolveDuration) || other.lastSolveDuration == lastSolveDuration)&&(identical(other.isProcessing, isProcessing) || other.isProcessing == isProcessing)&&(identical(other.autoSolveEnabled, autoSolveEnabled) || other.autoSolveEnabled == autoSolveEnabled)&&(identical(other.autoSolveIntervalSec, autoSolveIntervalSec) || other.autoSolveIntervalSec == autoSolveIntervalSec)&&(identical(other.ignoreExistingQueens, ignoreExistingQueens) || other.ignoreExistingQueens == ignoreExistingQueens)&&(identical(other.showCalibration, showCalibration) || other.showCalibration == showCalibration)&&(identical(other.badgeStyle, badgeStyle) || other.badgeStyle == badgeStyle)&&(identical(other.manualGridN, manualGridN) || other.manualGridN == manualGridN)&&(identical(other.cacheHits, cacheHits) || other.cacheHits == cacheHits)&&(identical(other.cacheMisses, cacheMisses) || other.cacheMisses == cacheMisses)&&(identical(other.cacheSize, cacheSize) || other.cacheSize == cacheSize));
}


@override
int get hashCode {
    return Object.hash(runtimeType,visionResult,solverResult,currentBoard,const DeepCollectionEquality().hash(_solutionQueens),const DeepCollectionEquality().hash(_fixedQueens),lastSolveDuration,isProcessing,autoSolveEnabled,autoSolveIntervalSec,ignoreExistingQueens,showCalibration,badgeStyle,manualGridN,cacheHits,cacheMisses,cacheSize);
}

@override
String toString() {
    return 'SolverState(visionResult: $visionResult, solverResult: $solverResult, currentBoard: $currentBoard, solutionQueens: $solutionQueens, fixedQueens: $fixedQueens, lastSolveDuration: $lastSolveDuration, isProcessing: $isProcessing, autoSolveEnabled: $autoSolveEnabled, autoSolveIntervalSec: $autoSolveIntervalSec, ignoreExistingQueens: $ignoreExistingQueens, showCalibration: $showCalibration, badgeStyle: $badgeStyle, manualGridN: $manualGridN, cacheHits: $cacheHits, cacheMisses: $cacheMisses, cacheSize: $cacheSize)';
}


}

/// @nodoc
abstract mixin class _$SolverStateCopyWith<$Res> implements $SolverStateCopyWith<$Res> {
  factory _$SolverStateCopyWith(_SolverState value, $Res Function(_SolverState) _then) = __$SolverStateCopyWithImpl;
@override @useResult
$Res call({
 VisionExtractionResult? visionResult, SolverResult? solverResult, PuzzleBoard? currentBoard, List<BoardCoordinate> solutionQueens, List<BoardCoordinate> fixedQueens, Duration? lastSolveDuration, bool isProcessing, bool autoSolveEnabled, double autoSolveIntervalSec, bool ignoreExistingQueens, bool showCalibration, SolutionBadgeStyle badgeStyle, int? manualGridN, int cacheHits, int cacheMisses, int cacheSize
});




}
/// @nodoc
class __$SolverStateCopyWithImpl<$Res>
    implements _$SolverStateCopyWith<$Res> {
  __$SolverStateCopyWithImpl(this._self, this._then);

  final _SolverState _self;
  final $Res Function(_SolverState) _then;

/// Create a copy of SolverState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? visionResult = freezed,Object? solverResult = freezed,Object? currentBoard = freezed,Object? solutionQueens = null,Object? fixedQueens = null,Object? lastSolveDuration = freezed,Object? isProcessing = null,Object? autoSolveEnabled = null,Object? autoSolveIntervalSec = null,Object? ignoreExistingQueens = null,Object? showCalibration = null,Object? badgeStyle = null,Object? manualGridN = freezed,Object? cacheHits = null,Object? cacheMisses = null,Object? cacheSize = null,}) {
  return _then(_SolverState(
visionResult: freezed == visionResult ? _self.visionResult : visionResult // ignore: cast_nullable_to_non_nullable
as VisionExtractionResult?,solverResult: freezed == solverResult ? _self.solverResult : solverResult // ignore: cast_nullable_to_non_nullable
as SolverResult?,currentBoard: freezed == currentBoard ? _self.currentBoard : currentBoard // ignore: cast_nullable_to_non_nullable
as PuzzleBoard?,solutionQueens: null == solutionQueens ? _self._solutionQueens : solutionQueens // ignore: cast_nullable_to_non_nullable
as List<BoardCoordinate>,fixedQueens: null == fixedQueens ? _self._fixedQueens : fixedQueens // ignore: cast_nullable_to_non_nullable
as List<BoardCoordinate>,lastSolveDuration: freezed == lastSolveDuration ? _self.lastSolveDuration : lastSolveDuration // ignore: cast_nullable_to_non_nullable
as Duration?,isProcessing: null == isProcessing ? _self.isProcessing : isProcessing // ignore: cast_nullable_to_non_nullable
as bool,autoSolveEnabled: null == autoSolveEnabled ? _self.autoSolveEnabled : autoSolveEnabled // ignore: cast_nullable_to_non_nullable
as bool,autoSolveIntervalSec: null == autoSolveIntervalSec ? _self.autoSolveIntervalSec : autoSolveIntervalSec // ignore: cast_nullable_to_non_nullable
as double,ignoreExistingQueens: null == ignoreExistingQueens ? _self.ignoreExistingQueens : ignoreExistingQueens // ignore: cast_nullable_to_non_nullable
as bool,showCalibration: null == showCalibration ? _self.showCalibration : showCalibration // ignore: cast_nullable_to_non_nullable
as bool,badgeStyle: null == badgeStyle ? _self.badgeStyle : badgeStyle // ignore: cast_nullable_to_non_nullable
as SolutionBadgeStyle,manualGridN: freezed == manualGridN ? _self.manualGridN : manualGridN // ignore: cast_nullable_to_non_nullable
as int?,cacheHits: null == cacheHits ? _self.cacheHits : cacheHits // ignore: cast_nullable_to_non_nullable
as int,cacheMisses: null == cacheMisses ? _self.cacheMisses : cacheMisses // ignore: cast_nullable_to_non_nullable
as int,cacheSize: null == cacheSize ? _self.cacheSize : cacheSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
