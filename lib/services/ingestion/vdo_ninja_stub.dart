import 'vdo_ninja_service.dart';

abstract class VdoNinjaPlatformAdapter {
  Future<void> initialize();
  Future<void> viewStream(String streamId, {String? room, String? password});
  Future<void> disconnect();
  void dispose();
}

VdoNinjaPlatformAdapter createVdoNinjaAdapter({
  required void Function(VdoStreamStatus status) onStatusChanged,
  required void Function(String message) onError,
  required void Function(dynamic stream) onStreamAvailable,
}) {
  return VdoNinjaStubAdapter();
}

class VdoNinjaStubAdapter implements VdoNinjaPlatformAdapter {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> viewStream(String streamId, {String? room, String? password}) async {}

  @override
  Future<void> disconnect() async {}

  @override
  void dispose() {}
}
