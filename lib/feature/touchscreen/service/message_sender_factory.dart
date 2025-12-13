import 'package:tesla_android/feature/touchscreen/service/message_sender.dart';
import 'message_sender_stub.dart'
    if (dart.library.js_interop) 'window_message_sender.dart';

class MessageSenderFactory {
  static MessageSender create() => createMessageSender();
}
