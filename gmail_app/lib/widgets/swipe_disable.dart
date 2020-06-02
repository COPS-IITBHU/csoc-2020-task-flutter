import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

//I created this widget with the help of internet as i didn't knew much about GestureRecognizerFactory but i am learning this part in more detail
class SwipeDisabler extends OneSequenceGestureRecognizer {
  int _x = 0;

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);
    if (_x == 0) {
      resolve(GestureDisposition.rejected);
      _x = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  String get debugDescription => "Swipe disabler Widget";

  @override
  void handleEvent(PointerEvent event) {
    if ((event.pointer == _x) && !event.down) {
      _x = 0;
    }
  }
}

class SwipeDisablerWidget extends StatelessWidget {
  final Widget child;
  SwipeDisablerWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        SwipeDisabler: GestureRecognizerFactoryWithHandlers<SwipeDisabler>(
          () => SwipeDisabler(),
          (SwipeDisabler instance) {},
        )
      },
      child: child,
    );
  }
}
