import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tesla_android/feature/touchscreen/cubit/touchscreen_cubit.dart';
import 'package:tesla_android/feature/touchscreen/service/message_sender.dart';

import 'touchscreen_cubit_test.mocks.dart';

@GenerateMocks([MessageSender])
void main() {
  group('TouchscreenCubit', () {
    late TouchscreenCubit cubit;
    late MockMessageSender mockMessageSender;

    setUp(() {
      mockMessageSender = MockMessageSender();
      cubit = TouchscreenCubit(mockMessageSender);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is false', () {
      expect(cubit.state, false);
    });

    test('handlePointerDownEvent sends correct command', () {
      final event = PointerDownEvent(
        pointer: 1,
        position: const Offset(100, 100),
      );
      const constraints = BoxConstraints(maxWidth: 1920, maxHeight: 1080);
      const touchscreenSize = Size(1920, 1080);

      cubit.handlePointerDownEvent(event, constraints, touchscreenSize);

      final captured = verify(
        mockMessageSender.postMessage(captureAny, '*'),
      ).captured;
      expect(captured.length, 1);
      final message = captured.first as String;

      expect(message, contains('T 1'));
      expect(message, contains('X 100'));
      expect(message, contains('Y 100'));
      expect(message, contains('S 0'));
    });

    test('handlePointerMoveEvent sends correct command', () {
      // First, put a pointer down to assign a slot
      final downEvent = PointerDownEvent(
        pointer: 1,
        position: const Offset(100, 100),
      );
      const constraints = BoxConstraints(maxWidth: 1920, maxHeight: 1080);
      const touchscreenSize = Size(1920, 1080);

      cubit.handlePointerDownEvent(downEvent, constraints, touchscreenSize);
      clearInteractions(mockMessageSender);

      final moveEvent = PointerMoveEvent(
        pointer: 1,
        position: const Offset(200, 200),
      );

      cubit.handlePointerMoveEvent(moveEvent, constraints, touchscreenSize);

      final captured = verify(
        mockMessageSender.postMessage(captureAny, '*'),
      ).captured;
      expect(captured.length, 1);
      final message = captured.first as String;

      expect(message, contains('X 200'));
      expect(message, contains('Y 200'));
      expect(message, contains('S 0'));
      expect(message, isNot(contains('T ')));
    });

    test('handlePointerUpEvent sends correct command', () {
      // Down first
      final downEvent = PointerDownEvent(
        pointer: 1,
        position: const Offset(100, 100),
      );
      const constraints = BoxConstraints(maxWidth: 1920, maxHeight: 1080);
      const touchscreenSize = Size(1920, 1080);

      cubit.handlePointerDownEvent(downEvent, constraints, touchscreenSize);
      clearInteractions(mockMessageSender);

      final upEvent = PointerUpEvent(
        pointer: 1,
        position: const Offset(100, 100),
      );

      cubit.handlePointerUpEvent(upEvent, constraints);

      final captured = verify(
        mockMessageSender.postMessage(captureAny, '*'),
      ).captured;
      expect(captured.length, 1);
      final message = captured.first as String;

      expect(message, contains('T -1'));
      expect(message, contains('S 0'));
    });

    test('resetTouchScreen sends reset commands', () {
      cubit.resetTouchScreen();

      final captured = verify(
        mockMessageSender.postMessage(captureAny, '*'),
      ).captured;
      expect(captured.length, 1);
      final message = captured.first as String;

      expect(message, contains('T -1'));
      expect(message, contains('S 0'));
    });
  });
}
