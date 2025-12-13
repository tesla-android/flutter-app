import 'package:tesla_android/feature/touchscreen/service/message_sender.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

class WindowMessageSender implements MessageSender {
  @override
  void postMessage(String message, String targetOrigin) {
    web.window.postMessage(message.toJS, targetOrigin.toJS);
  }
}

MessageSender createMessageSender() => WindowMessageSender();
