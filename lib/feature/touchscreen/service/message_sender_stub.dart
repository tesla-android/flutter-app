import 'package:tesla_android/feature/touchscreen/service/message_sender.dart';

class MessageSenderStub implements MessageSender {
  @override
  void postMessage(String message, String targetOrigin) {
    // No-op on VM
  }
}

MessageSender createMessageSender() => MessageSenderStub();
