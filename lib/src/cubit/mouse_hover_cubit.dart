import 'package:image_gallery_view/src/cubit/mouse_hover_state.dart';
import 'package:rxdart/subjects.dart';

class MouseHoverCubit {
  final BehaviorSubject<MouseHoverState> streamController =
      BehaviorSubject<MouseHoverState>.seeded(const MouseHoverState());

  Stream<MouseHoverState> get stream =>
      streamController.stream.asBroadcastStream();

  void toggleLeftSideHover(bool isHovering) {
    streamController.add(MouseHoverState(isLeftSideHovering: isHovering));
  }

  void toggleRightSideHover(bool isHovering) {
    streamController.add(MouseHoverState(isRightSideHovering: isHovering));
  }

  void dispose() {
    streamController.close();
  }
}
