import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_ai/state/chat_bloc.dart';
import 'package:open_ai/state/chat_state.dart';

class ResponseWidget extends StatelessWidget {
  const ResponseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        switch(state.runtimeType){
         case WaitState:
           return const CircularProgressIndicator();
         case ResponseState:
           return Text((state as ResponseState).response);
          case ErrorState:
            return Text((state as ErrorState).error);
         default:return Container();
       }

      },
    );
  }
}
