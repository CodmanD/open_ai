import 'package:flutter/material.dart';

@immutable
abstract class ChatEvent {}

class SendPromtEvent extends ChatEvent {
  String promt;

  SendPromtEvent(this.promt);
}

class SendMessageEvent extends ChatEvent {
  String message;

  SendMessageEvent(this.message);
}
