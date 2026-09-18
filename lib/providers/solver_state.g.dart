// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solver_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SolverController)
final solverControllerProvider = SolverControllerProvider._();

final class SolverControllerProvider
    extends $NotifierProvider<SolverController, SolverState> {
  SolverControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'solverControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$solverControllerHash();

  @$internal
  @override
  SolverController create() => SolverController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SolverState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SolverState>(value),
    );
  }
}

String _$solverControllerHash() => r'1bb807c7d5b67dcb2bbcac9b7b14cb962087fd00';

abstract class _$SolverController extends $Notifier<SolverState> {
  SolverState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SolverState, SolverState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SolverState, SolverState>,
              SolverState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
