import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_android/common/service/audio_service.dart';
import 'package:tesla_android/common/service/audio_service_factory.dart';
import 'package:tesla_android/common/service/window_service.dart';
import 'package:tesla_android/common/service/window_service_factory.dart';
import 'package:tesla_android/feature/touchscreen/service/message_sender.dart';
import 'package:tesla_android/feature/touchscreen/service/message_sender_factory.dart';
import 'package:tesla_android/common/di/flavor_factory.dart';
import 'package:flavor/flavor.dart';

void main() {
  group('Factory Tests', () {
    group('AudioServiceFactory', () {
      test('creates AudioService instance', () {
        final service = AudioServiceFactory.create();
        expect(service, isNotNull);
        expect(service, isA<AudioService>());
      });

      test('creates new instance each time', () {
        final service1 = AudioServiceFactory.create();
        final service2 = AudioServiceFactory.create();
        expect(identical(service1, service2), isFalse);
      });

      test('created instance has expected interface', () {
        final service = AudioServiceFactory.create();
        // Verify interface methods exist (stubs won't throw)
        expect(() => service.getAudioState(), returnsNormally);
        expect(() => service.stopAudio(), returnsNormally);
      });
    });

    group('WindowServiceFactory', () {
      test('creates WindowService instance', () {
        final service = WindowServiceFactory.create();
        expect(service, isNotNull);
        expect(service, isA<WindowService>());
      });

      test('creates new instance each time', () {
        final service1 = WindowServiceFactory.create();
        final service2 = WindowServiceFactory.create();
        expect(identical(service1, service2), isFalse);
      });

      test('created instance has expected interface', () {
        final service = WindowServiceFactory.create();
        // Verify interface method exists (stub won't throw)
        expect(() => service.reload(), returnsNormally);
      });
    });

    group('MessageSenderFactory', () {
      test('creates MessageSender instance', () {
        final sender = MessageSenderFactory.create();
        expect(sender, isNotNull);
        expect(sender, isA<MessageSender>());
      });

      test('creates new instance each time', () {
        final sender1 = MessageSenderFactory.create();
        final sender2 = MessageSenderFactory.create();
        expect(identical(sender1, sender2), isFalse);
      });

      test('created instance has expected interface', () {
        final sender = MessageSenderFactory.create();
        // Verify interface method exists (stub won't throw)
        expect(() => sender.postMessage('test', '*'), returnsNormally);
      });
    });

    group('FlavorFactory', () {
      test('creates Flavor instance', () {
        final flavor = FlavorFactory.create();
        expect(flavor, isNotNull);
        expect(flavor, isA<Flavor>());
      });

      test('creates consistent configuration', () {
        final flavor1 = FlavorFactory.create();
        final flavor2 = FlavorFactory.create();
        // Both should provide the same configuration values
        // even if they are different instances
        expect(flavor1.runtimeType, equals(flavor2.runtimeType));
      });
    });
  });
}
