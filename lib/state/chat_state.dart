import 'package:flutter/material.dart';

@immutable
abstract class ChatState {}

class InitState extends ChatState {}

class WaitState extends ChatState {}

class ReadyState extends ChatState {}

class ResponseState extends ChatState {
  final String response;

  ResponseState(this.response);
}

class ErrorState extends ChatState {
  final String error;

  ErrorState(this.error);
}
