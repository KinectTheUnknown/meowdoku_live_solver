// Stub non-web implementation for VM / unit tests
import 'package:flutter/widgets.dart';

class WebVideoManagerImpl {
  dynamic get videoElement => null;
  int get videoWidth => 0;
  int get videoHeight => 0;

  void initialize(String viewType, VoidCallback onLoadedMetadata) {}

  void attachStream(dynamic stream) {}

  void detachStream() {}

  void dispose() {}
}
