import 'dart:async';
import 'package:rxdart/subjects.dart';

class ImageGalleryCubit {
  ImageGalleryCubit({int index = 0}) {
    streamController = BehaviorSubject<int>.seeded(index);
  }

  late final BehaviorSubject<int> streamController;

  /// [ImageGalleryCubit] state stream
  Stream<int> get stream => streamController.stream.asBroadcastStream();

  /// Change index of active image
  void changeActiveImage(int index) {
    streamController.add(index);
  }

  void moveToPreviousImage() {
    if (streamController.value > 0) {
      changeActiveImage(streamController.value - 1);
    }
  }

  void moveToNextImage(int imageLength) {
    if (streamController.value < imageLength - 1) {
      changeActiveImage(streamController.value + 1);
    }
  }

  /// Close stream
  void dispose() {
    streamController.close();
  }
}
