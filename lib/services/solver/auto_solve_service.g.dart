// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_solve_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AutoSolveService)
final autoSolveServiceProvider = AutoSolveServiceProvider._();

final class AutoSolveServiceProvider
    extends $NotifierProvider<AutoSolveService, bool> {
  AutoSolveServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSolveServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSolveServiceHash();

  @$internal
  @override
  AutoSolveService create() => AutoSolveService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$autoSolveServiceHash() => r'8ae9a3563d8d734bb7c7b89024e07ab311b3e2e7';

abstract class _$AutoSolveService extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
