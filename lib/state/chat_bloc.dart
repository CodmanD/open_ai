import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_ai/state/chat_event.dart';
import 'package:open_ai/state/chat_state.dart';
import 'package:openai_client/openai_client.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late final OpenAIClient _client;
  final String prompt =
      'перепиши дане звернення по схемі ненасильницького спілкування, яка описана в книзі "Ненасильницьке спілкування" Маршала Розенберга.';
  final String _example =
      'Не підвищуй на мене голос, все що тебе тривожить, можна обговорити спокійно';
  final String model = "gpt-3.5-turbo";
  final String modelDavinci = "text-davinci-edit-001";

  ChatBloc(super.initialState) {
    // emit(WaitState());
    setupChat();
    on<SendPromtEvent>((event, emit) {});
    on<SendMessageEvent>((event, emit) async {
      emit(WaitState());
      if (event.message.isEmpty) {
        emit(ErrorState("Error:пусте поле вводу"));
        return;
      }
      final edit = await _client.edits
          .create(model: modelDavinci, instruction: prompt, input: event.message)
          .data;
      emit(ResponseState(edit.choices.first.text));
    });
  }

  setupChat() async {
    final configuration = await loadConfigurationFromEnvFile();
    _client = OpenAIClient(
      configuration: configuration,
      enableLogging: true,
    );
    emit(ReadyState());
  }


  Future<OpenAIConfiguration> loadConfigurationFromEnvFile() async {
    final String apiKey = dotenv.get('new_key');
    return OpenAIConfiguration(
      apiKey: apiKey,
    );
  }
}
