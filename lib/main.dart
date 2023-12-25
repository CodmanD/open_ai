import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_ai/state/chat_bloc.dart';
import 'package:open_ai/state/chat_event.dart';
import 'package:open_ai/state/chat_state.dart';
import 'package:open_ai/widgets/response_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocProvider(
          create: (context) => ChatBloc(InitState()),
          child: const MyHomePage(
            title: 'OpenAI',
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //TODO: Усі Strings до констант , чи до файлів локалізаторів
              Text("ChatGPT повертає звернення на підставі промту: перепиши дане звернення по схемі ненасильницького спілкування, яка описана в книзу \"Ненасильницьке спілкування\" Маршала Розенберга."),
              SizedBox(height: 50,),
              Flexible(child:ResponseWidget()),
            ],
          ),
        ),
      ),
      bottomSheet: SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextField(
            controller: _ctrl,
            onSubmitted: (value) {
              context.read<ChatBloc>().add(SendMessageEvent(value));
              FocusScope.of(context).unfocus();
            },
            textAlign: TextAlign.left,
            decoration: const InputDecoration.collapsed(
                hintText: 'Type here...', fillColor: Colors.yellow),
            onChanged: (value) {},
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // context.read<ChatBloc>().add(SendMessageEvent("Дорогая , я хочу шоб вечеря була кожен день у сьомій годині"));
          context.read<ChatBloc>().add(SendMessageEvent(_ctrl.text));
          FocusScope.of(context).unfocus();
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
