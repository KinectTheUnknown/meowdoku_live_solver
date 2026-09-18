// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vdo_ninja_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Generated Riverpod notifier for VDO.Ninja streaming integration.

@ProviderFor(VdoNinjaStream)
final vdoNinjaStreamProvider = VdoNinjaStreamProvider._();

/// Generated Riverpod notifier for VDO.Ninja streaming integration.
final class VdoNinjaStreamProvider
    extends $NotifierProvider<VdoNinjaStream, VdoStreamState> {
  /// Generated Riverpod notifier for VDO.Ninja streaming integration.
  VdoNinjaStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vdoNinjaStreamProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vdoNinjaStreamHash();

  @$internal
  @override
  VdoNinjaStream create() => VdoNinjaStream();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VdoStreamState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VdoStreamState>(value),
    );
  }
}

String _$vdoNinjaStreamHash() => r'c18f9b4f221e5fa8762acd2bcdb03ca83e5600e6';

/// Generated Riverpod notifier for VDO.Ninja streaming integration.

abstract class _$VdoNinjaStream extends $Notifier<VdoStreamState> {
  VdoStreamState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<VdoStreamState, VdoStreamState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VdoStreamState, VdoStreamState>,
              VdoStreamState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
